# Goal
Phase 5-6 を実装し、G-Runner Flutter 版を Act 1 Complete + Full Loop マイルストーンに到達させる。
Boss ステージ (Stage 5) で Act 1 を完結し、ステージ選択・フォーム選択・通貨・アップグレード・セーブデータで周回プレイの動機付けを構築する。

# Context
- Phase 0-4 完了済み: 5敵種, コンボ/覚醒/EX, フォーム/Transform, Stage 1-4
- Phase 5 完了で Act 1 Complete マイルストーン到達
- Phase 6 完了で Full Loop マイルストーン到達 (メタゲーム周回が成立)
- RN版は Boss 3体 + 15ステージ + Endless を持つ。本スコープでは Boss 1 + Stage 5 + メタゲーム基盤を移植

# Scope

## In Scope
### Phase 5: ボスステージ (Act 1 完結)
- Boss エンティティ (HP500, 200x120, ホバー移動: 振幅30px/周期3s)
- Boss 攻撃パターン 3段階
  - Phase 1 (HP 100-66%): 5方向弾 (15°間隔, ATK15, 2.0s間隔)
  - Phase 2 (HP 66-33%): 弾速UP + 発射間隔短縮
  - Phase 3 (HP 33-0%): ドローン召喚 (3体, HP25)
- Boss Phase ゲームルール (スクロール0.5倍, 通常スポーン停止, ボス撃破=ステージクリア)
- Boss HP バー (画面上部, フェーズ色変化)
- Stage 5 タイムライン (180秒: 前半60秒=通常wave, 60秒以降=Boss出現)

### Phase 6: メタゲーム
- ステージ選択画面 (クリア済み表示, ハイスコア, 次ステージアンロック)
- フォーム選択画面 (Primary/Secondary 選択, フォームステータス表示)
- クレジット (通貨) システム (敵撃破1-3Cr, ステージクリア50Cr, ボス撃破150Cr)
- アップグレードショップ (ATK +2/Lv max10, HP +10/Lv max10, Speed +5%/Lv max5, DEF +3%/Lv max5)
- セーブデータ永続化 (shared_preferences: ハイスコア, アンロック, アップグレード, クレジット)

## Out of Scope
- Boss 2, 3 (Phase 7)
- Stage 6-15 (Phase 7)
- 追加フォーム (Sniper, Scatter, Guardian) のアンロック購入 → Phase 7
- Endless モード → Phase 7
- 実績システム → Phase 7
- Graze / Parry / Just Transform → Phase 7
- フォームXP & スキルツリー → Phase 7
- Credit Boost アップグレード → Phase 7
- 設定画面 (BGM/SE/言語) → Phase 7

# Expected Output

### 新規ファイル
- `lib/game/components/boss.dart` — Boss エンティティ (ホバー移動, 3段階攻撃, HP管理)
- `lib/game/data/stage5_data.dart` — Stage 5 タイムライン (180秒, Boss spawn)
- `lib/screens/stage_select_screen.dart` — ステージ選択画面
- `lib/screens/form_select_screen.dart` — フォーム選択画面
- `lib/screens/upgrade_shop_screen.dart` — アップグレードショップ画面
- `lib/data/game_progress.dart` — セーブデータ管理 (shared_preferences)

### 変更ファイル
- `lib/game/data/stage_data.dart` — SpawnEventType.boss 追加, StageData にメタデータ (hasBoss, creditReward)
- `lib/game/data/constants.dart` — Boss ステータス, アップグレード定数, クレジット定数
- `lib/game/g_runner_game.dart` — Boss phase 統合 (スクロール減速, スポーン停止, Boss 衝突判定, ボス撃破=クリア)
- `lib/game/ui/hud.dart` — Boss HP バー, Boss Phase 表示
- `lib/game/components/player.dart` — アップグレードによるベースステータス加算
- `lib/screens/title_screen.dart` — ナビゲーション変更 (→ ステージ選択へ)
- `lib/screens/game_screen.dart` — ステージ/フォーム選択データの受け取り
- `lib/screens/result_screen.dart` — クレジット獲得表示, 次ステージボタン, アップグレードボタン
- `lib/main.dart` — ルーティング追加
- `pubspec.yaml` — shared_preferences 依存追加

# References

## RN版の関連ファイル
| ファイル | 内容 |
|---------|------|
| `src/engine/entities/Boss.ts` | Boss エンティティ (HP, 移動, 攻撃パターン, Phase遷移) |
| `src/game/stages/stage5.ts` | Stage 5 "Core Breach" タイムライン (180秒, 60秒でBoss出現) |
| `src/stores/saveDataStore.ts` | セーブデータ (highScores, unlockedStages/Forms, credits, upgrades) |
| `src/stores/gameSessionStore.ts` | ゲームセッション状態 (credits, score, form) |
| `app/stages/index.tsx` | ステージ選択UI (カード表示, ロック/アンロック, ハイスコア) |
| `app/stages/[id]/select-form.tsx` | フォーム選択UI (Primary/Secondary, ステータス表示, アンロック) |
| `app/upgrade.tsx` | アップグレードショップUI (5種ステータス, レベルバー, コスト表示) |
| `src/constants/balance.ts` | Boss定数, クレジット定数, アップグレード定数 |

## 実装ノート

### Boss バランス値 (RN版準拠)
| パラメータ | 値 |
|-----------|-----|
| HP | 500 |
| サイズ | 200×120 |
| ホバー位置 | Y=40 (画面上部) |
| ホバー振幅 | 30u, 周期3s |
| Phase 1 攻撃 | 5方向弾, 15°間隔, ATK15, 2.0s間隔 |
| Phase 2 閾値 | HP 66% — 弾速UP + 間隔短縮 |
| Phase 3 閾値 | HP 33% — ドローン召喚3体 (HP25) |
| スクロール速度 | 通常の0.5倍 (Boss Phase中) |

### Boss Phase 遷移ロジック
1. Boss spawn → スライドイン (Y=-120 → Y=40, 速度30u/s)
2. HP 100-66%: Phase 1 — 5方向弾のみ
3. HP 66-33%: Phase 2 — 弾速UP + 発射間隔短縮
4. HP 33-0%: Phase 3 — ドローン召喚 (3体の Stationary 敵)
5. HP 0: 大爆発パーティクル (16方向) + スクリーンシェイク (強度8, 0.3s) → ステージクリア

### Boss Phase ゲームルール
- Boss 出現時にスクロール速度を0.5倍に
- 通常敵・Gate のスポーンを停止
- ボス撃破 = 即座にステージクリア (残り時間無関係)
- Boss HP バーを画面上部に専用表示

### クレジットシステム
| ソース | 獲得量 |
|--------|--------|
| 敵撃破 (Stationary) | 1 Cr |
| 敵撃破 (Patrol) | 2 Cr |
| 敵撃破 (Rush) | 1 Cr |
| 敵撃破 (Swarm) | 0 Cr |
| 敵撃破 (Phalanx) | 4 Cr |
| ステージクリア | 50 Cr |
| ボス撃破 | 150 Cr |

### アップグレード定義
| ステータス | 効果/Lv | 最大Lv | コスト式 |
|-----------|---------|--------|---------|
| ATK | +2 | 10 | 100 × (Lv+1) |
| HP | +10 | 10 | 100 × (Lv+1) |
| Speed | +5% | 5 | 100 × (Lv+1) |
| DEF | +3% | 5 | 150 × (Lv+1) |

### セーブデータ構造
```dart
class GameProgress {
  List<int> unlockedStages;     // 初期: [1]
  Map<int, int> highScores;     // stageId → score
  int credits;                  // 初期: 0
  List<FormType> unlockedForms; // 初期: [standard]
  UpgradeLevels upgrades;       // 初期: 全て0
}
```

### ナビゲーションフロー (Phase 6 後)
```
TitleScreen
  → StageSelectScreen (ステージ選択)
    → FormSelectScreen (フォーム選択, Primary/Secondary)
      → GameScreen (ゲームプレイ)
        → ResultScreen (結果 + クレジット表示)
          → UpgradeShopScreen (アップグレード)
          → StageSelectScreen (次ステージ)
          → TitleScreen
```

# Design Notes

### 実装順序の推奨
Phase 5 → 6 の順で実装。Phase 5 は既存ゲームエンジンの拡張、Phase 6 は Flutter Widget 層の新規画面が中心。

### Phase 5 の設計方針
- **Boss コンポーネント**: `Enemy` とは別クラスとして実装 (サイズ・挙動が大きく異なるため)
- **Boss Phase 管理**: Boss 内部で HP 閾値を監視し phase を遷移。GRunnerGame は `isBossPhase` フラグでスクロール・スポーンを制御
- **Stage 5 タイムライン**: 前半60秒は通常 wave (高難度構成)、60秒時点で `SpawnEvent.boss` を発火
- **ボス撃破判定**: `_checkCollisions()` 内で Boss へのダメージを処理。Boss.hp <= 0 で `onBossDefeated()` → stageClear

### Phase 6 の設計方針
- **セーブデータ**: `shared_preferences` で JSON シリアライズ。`GameProgress` シングルトンでアプリ起動時にロード
- **ステージ選択**: Stage 1-5 のカード一覧。クリア済みなら次ステージをアンロック。ハイスコア表示
- **フォーム選択**: 現在は Standard / Heavy Artillery / High Speed の3種。Primary + Secondary 選択必須
- **アップグレード**: コスト式 = `baseCost × (currentLevel + 1)`。Player 初期化時にアップグレード値を加算
- **クレジット**: ゲーム中に蓄積し、ResultScreen で確定。GameProgress に加算して永続化

### RN版との差異
- RN版はフォームアンロックにクレジット消費が必要。Flutter版 Phase 6 では3フォーム全てアンロック済みとし、追加フォームの有料アンロックは Phase 7 に延期
- RN版の Credit Boost アップグレードは Phase 7 に延期
- RN版の Endless モードは Phase 7 に延期
