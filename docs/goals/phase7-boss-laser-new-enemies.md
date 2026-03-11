# Goal
Phase 7 を実装し、Boss にレーザー攻撃パターンを追加、6種の新敵を実装して Act 2 の基盤を構築する。

# Context
- Phase 0-6 完了済み: 5敵種, 3フォーム, 1ボス (スプレッド+ドローン), 5ステージ, メタゲーム周回
- Phase 7 は Phase 8 (Act 2: Stage 6-10 + Boss 2) のブロッカー
- 新敵種は Stage 6-15 全体で使用されるため、早期に基盤を確立する必要がある
- Boss レーザーは Boss 2/3 の必須攻撃パターン

# Scope

## In Scope
- Boss レーザー攻撃パターン (warning → firing ステートマシン)
- 新敵種 6体: Juggernaut, Dodger, Splitter, Summoner, Sentinel, Carrier
- 各敵のバランス定数・スコア・クレジット
- 衝突判定の拡張 (新敵種の特殊メカニクス)
- ポーズメニュー (小スコープだが UX に直結)

## Out of Scope
- Stage 6-10 タイムライン (Phase 8)
- Boss 2/3 のインスタンス生成 (Phase 8/10)
- 難易度スケーリングシステム (Phase 8)
- 新フォーム (Phase 9)

# Expected Output

### 変更ファイル
- `lib/game/data/constants.dart` — 新敵種ステータス、Boss レーザー定数
- `lib/game/data/stage_data.dart` — EnemyType enum に6種追加
- `lib/game/components/enemy.dart` — 6種の移動AI・射撃・特殊メカニクス
- `lib/game/components/boss.dart` — レーザー攻撃ステートマシン、レーザー描画
- `lib/game/g_runner_game.dart` — 新敵種の衝突判定 (Sentinel シールド, Splitter 分裂, Summoner/Carrier スポーン)、ポーズ機能

### 新規ファイル
- `lib/game/ui/pause_overlay.dart` — ポーズメニュー (Resume / Exit)

# References

## RN版の関連ファイル
| ファイル | 内容 |
|---------|------|
| `src/engine/entities/Enemy.ts` | 全敵種のエンティティ生成・初期化 |
| `src/engine/systems/EnemyAISystem.ts` | 敵の移動AI・射撃・特殊メカニクス |
| `src/engine/entities/Boss.ts` | Boss レーザーステート管理 |
| `src/engine/systems/BossSystem.ts` | Boss レーザー攻撃の実装 (warning/firing/cooldown) |
| `src/engine/systems/CollisionSystem.ts` | Splitter 分裂処理 |
| `src/constants/balance.ts` | 全敵種バランス定数 |
| `src/types/enemies.ts` | 敵種 enum, ステータス型定義 |
| `src/rendering/shapes.ts` | 敵の形状描画 |

## 実装ノート

### 新敵種バランス値 (RN版準拠)

| 敵種 | HP | ATK | 射撃間隔 | 移動速度 | スコア | Cr | サイズ |
|------|-----|-----|----------|----------|--------|-----|--------|
| Juggernaut | 120 | 25 | 1.5s | scroll×0.3 | 500 | 7 | 56×48 |
| Dodger | 35 | 12 | 1.8s | 120 (回避) | 250 | 3 | 28×28 |
| Splitter | 50 | 8 | 2.0s | scroll標準 | 200 | 3 | 32×32 |
| Summoner | 80 | 0 | — | 静止 | 400 | 5 | 36×36 |
| Sentinel | 120 | 15 | 2.0s | 静止 | 600 | 7 | 36×36 |
| Carrier | 100 | 0 | — | scroll×0.5 | 500 | 6 | 34×34 |

### 新敵種の移動AI・特殊メカニクス

#### Juggernaut (重装型)
- 降下速度: baseScrollSpeed × 0.3 (= 24 u/s)
- 水平移動: 正弦波 (振幅20u)
- 射撃: 3砲塔ラウンドロビン (幅0.2/0.5/0.8 オフセット、直下射撃)
- 色: 紫 `#AA44FF`、形状: 六角形

#### Dodger (回避型)
- 通常は静止
- プレイヤー弾検知: 半径60u、上方120u以内の弾を検知
- 回避: 弾の反対方向に120u/sで移動、0.8sクールダウン
- 射撃: プレイヤー方向への照準弾
- 色: シアン `#44DDFF`、形状: ダイヤモンド

#### Splitter (分裂型)
- 降下速度: baseScrollSpeed 標準 (80 u/s)
- 射撃: 直下射撃
- **撃破時**: 3体の Swarm を生成 (オフセット: -20, 0, +20)
- 色: オレンジ `#FF8800`、形状: ダイヤモンド

#### Summoner (召喚型)
- 完全静止
- 射撃なし
- 3.0秒ごとに Swarm を2体召喚 (左-20、右+20)
- 最大同時 Swarm 数: 6体
- 色: ゴールド `#DDAA00`、形状: ダイヤモンド

#### Sentinel (盾役)
- 完全静止
- 3方向スプレッド射撃 (中央 + 左30° + 右30°)
- **シールド**: 全ダメージ 50%軽減 (SENTINEL_SHIELD_REDUCTION = 0.5)
- 色: 赤 `#FF4466`、形状: 五角形

#### Carrier (搬送型)
- 降下速度: baseScrollSpeed × 0.5 (= 40 u/s)
- 水平パトロール: 36 u/s (patrol標準 × 0.6)
- 射撃なし
- 5.0秒ごとに Patrol 敵を2体召喚 (左-25、右+25)
- 色: 緑 `#88CC44`、形状: ダイヤモンド

### Boss レーザー攻撃

#### ステートマシン
```
idle → warning (1.0s) → firing (1.5s) → cooldown (4.0s) → idle
```

#### パラメータ
| パラメータ | 値 |
|-----------|-----|
| 警告時間 | 1000ms |
| 照射時間 | 1500ms |
| レーザー幅 | 30u (Boss 1/2), 40u (Boss 3) |
| ダメージ/tick | 20 |
| tick間隔 | 300ms |
| クールダウン | 4000ms |
| 合計最大ダメージ | 100 (5tick × 20) |

#### Boss Phase との統合
- **Spread Phase**: レーザー無効、スプレッド弾のみ (現行 Phase 1)
- **Laser Phase**: スプレッドとレーザーを交互 (Phase 2 以降)
- レーザー位置: Boss の中心X座標に固定
- ヒット判定: プレイヤーX が レーザー中心 ± (幅/2) 以内
- ヒット時: ダメージ + iframe + コンボリセット + シェイク

#### 描画
- 警告フェーズ: パルスアニメーション (sin波、周波数8 rad/s)、半透明の赤い縦線
- 照射フェーズ: 明るい赤のビーム、Boss下端 → 画面下端

### ポーズメニュー
- ゲーム中にポーズボタン (HUD 右上)
- ポーズ中: `GameState.paused` 追加、update() スキップ
- Resume: ゲーム再開
- Exit: ステージ選択画面に戻る

# Design Notes

### 実装順序の推奨
1. **定数・enum 追加** (constants.dart, stage_data.dart)
2. **Boss レーザー** (boss.dart — ステートマシン + 描画)
3. **新敵種 (基本3種)** — Juggernaut, Splitter, Sentinel (比較的シンプル)
4. **新敵種 (AI型3種)** — Dodger, Summoner, Carrier (スポーンや弾検知が複雑)
5. **衝突判定拡張** (g_runner_game.dart — Sentinel シールド, Splitter 分裂, スポーン敵)
6. **ポーズメニュー** (pause_overlay.dart, GameState 拡張)

### 設計方針
- **Splitter 分裂**: `onEnemyKilled()` 内で Splitter かチェックし、3体の Swarm を追加スポーン
- **Summoner/Carrier スポーン**: Enemy 内部の `_spawnTimer` で管理、`game.world.add()` で直接スポーン
- **Dodger 回避**: `update()` 内で `game.world.children.whereType<PlayerBullet>()` を参照し、距離チェック
- **Sentinel シールド**: `takeDamage()` で一律 50%軽減 (Phalanx の方向依存シールドとは異なる)
- **Boss レーザー**: Boss クラスに `LaserState` enum と関連タイマーを追加。`render()` でビーム描画
- **ポーズ**: `GameState` enum に `paused` を追加。HUD ボタン → `game.togglePause()`

### RN版との差異
- RN版の Dodger は実際の弾オブジェクトを距離チェックしている。Flutter版も同様に `whereType<PlayerBullet>()` で実装可能
- RN版の Summoner は spawned swarm を追跡している。Flutter版は `world.children.whereType<Enemy>().where((e) => e.type == EnemyType.swarm).length` でカウント
- Boss レーザーの hit detection は RN版ではプレイヤーX座標のみで判定 (Y方向は全域)。Flutter版も同様
