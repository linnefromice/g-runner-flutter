# Goal
Phase 2-4 を実装し、G-Runner Flutter 版を Alpha マイルストーンに到達させる。
新敵種 (Rush, Swarm, Phalanx) + Stage 2-4、コンボ/覚醒/EXバーストシステム、フォーム/Transform システム + Tradeoff Gate を追加し、戦略的なゲームプレイ体験を構築する。

# Context
- Phase 0-1 完了済み: Stage 1 プレイ可能、基本ゲーム体験 (2敵種, 3Gate種, HUD, スクリーンシェイク, スコアポップアップ)
- IMPLEMENTATION_PLAN.md の Alpha マイルストーン = Phase 2-3 (5敵種, コンボ/覚醒/EX, Stage 1-4)
- Phase 4 (フォーム/Transform) を含めることで Act 1 Complete の前段階まで到達
- RN版は11敵種・7フォーム・15ステージを持つ完全版。本スコープではその中核メカニクスを移植

# Scope

## In Scope
### Phase 2: 敵バリエーション + Stage 2-4
- Rush敵 (HP15, 射撃なし, 200u/s高速突進, プレイヤー追尾)
- Swarm敵 (HP1, 射撃なし, 正弦波横揺れ, 群れ出現)
- Phalanx敵 (HP60, 3方向弾, 前面シールド=上半分ダメージ半減)
- Stage 2 タイムライン (90秒)
- Stage 3-4 タイムライン (各90秒)

### Phase 3: コンボ & 覚醒 + EXバースト
- コンボゲージ (Gate通過+1, 被ダメリセット, 3段階)
- 覚醒フォーム (コンボ3で自動発動, 10秒間, ATK2.0/SPD1.2/FR1.3, 追尾弾, 無敵)
- 覚醒タイマー HUD
- EXゲージ (max100, 敵撃破+5/Gate+10/ボス+2)
- EXバースト (全画面ビーム, 50dmg/tick, 2秒間, 幅80u)

### Phase 4: フォーム & Transform
- フォーム定義 (Standard / Heavy Artillery / High Speed)
- Transformゲージ (max100, 敵撃破+8/Gate+12/時間+2/s)
- フォーム切替メカニクス (Primary/Secondary, 切替後5秒バフ)
- Tradeoff Gate (左右で異なるトレードオフ効果, 黄色表示)
- 特殊弾種 (Heavy Artillery=爆発弾40px範囲, High Speed=貫通弾)

## Out of Scope
- ボス戦 (Phase 5)
- 追加フォーム (Sniper, Scatter, Guardian) → Phase 7
- 追加敵種 (Dodger, Splitter, Summoner, Sentinel, Juggernaut, Carrier) → Phase 7
- Graze メカニクス → Phase 7
- フォームXP & スキルツリー → Phase 7
- Refit Gate / Growth Gate / Roulette Gate → Phase 7
- メタゲーム (ステージ選択, 通貨, アップグレード) → Phase 6
- セーブデータ永続化 → Phase 6
- フォーム選択画面 (ステージ開始前) → Phase 6

# Expected Output

### 新規ファイル
- `lib/game/components/ex_burst.dart` — EXバーストビームコンポーネント
- `lib/game/data/stage2_data.dart` — Stage 2 タイムライン
- `lib/game/data/stage3_data.dart` — Stage 3 タイムライン
- `lib/game/data/stage4_data.dart` — Stage 4 タイムライン

### 変更ファイル
- `lib/game/components/enemy.dart` — Rush, Swarm, Phalanx 追加 + 各種AI
- `lib/game/components/player.dart` — コンボ/覚醒/EX/フォーム状態管理
- `lib/game/components/bullet.dart` — 爆発弾・貫通弾・追尾弾の弾種追加
- `lib/game/components/gate.dart` — Tradeoff Gate 追加 (黄色, 双方向効果)
- `lib/game/g_runner_game.dart` — 新システム統合 (覚醒発動, EXバースト, フォーム切替, 新敵スポーン, 新衝突判定)
- `lib/game/data/constants.dart` — 新敵種ステータス, フォーム定義, ゲージ定数
- `lib/game/data/stage_data.dart` — SpawnEvent拡張 (新敵種対応)
- `lib/game/ui/hud.dart` — コンボゲージ, 覚醒タイマー, EXゲージ, フォーム表示, Transformゲージ

# References

## RN版の関連ファイル
| ファイル | 内容 |
|---------|------|
| `src/constants/balance.ts` | 全バランス定数 (敵HP/ATK/スコア, ゲージ充填率, フォーム倍率) |
| `src/constants/forms.ts` | フォーム定義 (7種, 弾設定, 特殊能力) |
| `src/constants/gates.ts` | Gate効果定義 (Enhance/Recovery/Tradeoff/Refit/Growth/Roulette) |
| `src/engine/systems/enemySystem.ts` | 敵AI (Rush追尾, Swarm正弦波, Phalanxシールド, 各種スポーン) |
| `src/engine/systems/comboSystem.ts` | コンボ→覚醒の発動ロジック |
| `src/engine/systems/exBurstSystem.ts` | EXゲージ蓄積 & バーストビーム判定 |
| `src/engine/systems/formSystem.ts` | Transform切替 & バフタイマー |
| `src/engine/systems/bulletSystem.ts` | 弾種ロジック (爆発/貫通/追尾) |

## 実装ノート

### 敵種バランス値 (RN版準拠)
| 敵種 | HP | ATK | 射撃間隔 | 移動速度 | スコア | ヒットボックス |
|------|-----|-----|---------|---------|--------|-------------|
| Rush | 15 | 15 (接触) | なし | 200 u/s | 100 | 28×28 |
| Swarm | 1 | 5 (接触) | なし | 80 u/s + sin波 | 30 | 16×16 |
| Phalanx | 60 | 15 | 2.0s (3方向) | 40 u/s (横) | 300 | 36×36 |

### Rush敵の追尾AI
- プレイヤーのX座標を追尾しつつ高速下降
- `x += sign(playerX - enemyX) * min(abs(dx), RUSH_SPEED * 0.5 * dt)`
- 接触判定を衝突システムに追加

### Phalanxシールド判定
- 弾の中心Y < 敵の中心Y → シールド判定 (ダメージ半減)
- 弾の中心Y >= 敵の中心Y → 通常ダメージ
- シールド部分は青い半透明エフェクト描画

### コンボ→覚醒フロー
1. Gate通過で comboCount+1
2. comboCount >= 3 で覚醒自動発動
3. 発動時: 0.3倍スローモーション 300ms → 覚醒フォーム切替
4. 10秒間: ATK2.0倍, SPD1.2倍, FR1.3倍, 追尾弾, 無敵
5. 残り3秒で警告表示
6. 終了時: comboCount=0 にリセット

### EXバーストビーム
- プレイヤー中心から上方向に幅80uのビーム
- 100msごとに50ダメージの持続ダメージ
- ビーム内の敵弾も消滅
- Tradeoff Gate もビームで破壊可能 (RN版固有仕様)

### フォーム定義 (Phase 4 スコープ)
| フォーム | SPD倍率 | ATK倍率 | FR倍率 | 特殊弾 | 弾色 |
|---------|---------|---------|--------|--------|------|
| Standard | 1.0 | 1.0 | 1.0 | なし | 青 #00D4FF |
| Heavy Artillery | 0.8 | 1.8 | 0.6 | 爆発 (40px範囲) | 橙 #FF6600 |
| High Speed | 1.4 | 0.7 | 1.5 | 貫通 | 緑 #00FF88 |

### Transform 切替
- ゲージ満タンで Primary ↔ Secondary 切替
- 切替後5秒間: ATK1.25倍, SPD1.15倍, FR1.2倍, HP+5回復
- 覚醒中はTransform不可

# Design Notes

### 実装順序の推奨
Phase 2 → 3 → 4 の順で段階的に実装。各 Phase 内も番号順に進める。
各 Phase 完了時に `flutter analyze` + 動作確認を行う。

### 既存アーキテクチャとの整合
- **敵追加**: `EnemyType` enum 拡張 + `_statsFor()` に分岐追加。Rush/Swarm/Phalanx それぞれ `update()` で分岐する AI ロジック
- **ゲージ系 (コンボ/EX/Transform)**: `GRunnerGame` に状態を持ち、`update()` で蓄積・発動を管理。HUD へコールバックで通知
- **覚醒フォーム**: Player の一時的な状態変更として実装。専用弾種を `BulletType` enum で管理
- **フォームシステム**: `FormDefinition` データクラスを新設。Player が現在フォームを保持し、弾種・倍率を参照
- **Tradeoff Gate**: `GateEffectType` に `tradeoff` 系を追加。`_applyGateEffect()` で正負両方の効果を適用

### RN版との差異
- RN版は ECS (Entity-Component-System) パターン。Flutter版は Flame のコンポーネントツリー + 中央ゲームクラス方式
- RN版の各 System (enemySystem, comboSystem, etc.) の責務を `GRunnerGame` のメソッドに統合
- ステージデータは RN版と同じタイムライン駆動方式を維持
