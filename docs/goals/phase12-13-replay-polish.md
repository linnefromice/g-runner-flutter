# Goal
Endless モードと実績システムでリプレイ性を確立し、
Debris/Boost Lane/Credit Boost/設定/i18n/How-to-Play で UX を完成させる。

# Context
- Phase 0-11 完了: 全15ステージ、Boss 3、6フォーム、スキルツリー、Graze/Parry 実装済み
- IMPLEMENTATION_PLAN.md の Phase 12 + Phase 13 に該当
- マイルストーン:「Replay Complete」+「Content Complete」を同時達成
- ポーズ機能 (13.1) は Phase 7.8 で既に実装済みのためスキップ

# Scope
## In Scope
### Phase 12: Endless + 実績
- Endless モード (動的 wave 生成、時間ベース難易度漸増)
- 実績システム 10種 (条件判定 + クレジット報酬)
- 実績画面 (達成/未達成リスト + 報酬受取)
- Endless ハイスコア/ベストタイム永続化
- タイトル画面に Endless / 実績メニュー追加

### Phase 13: UX ポリッシュ
- Debris システム (HP50, 40×40, 撃破+50pt)
- Boost Lane (スコア ×1.5, スクロール ×1.3)
- Credit Boost アップグレード (+10%/Lv, max 5, コスト 200×(Lv+1))
- 設定画面 (BGM/SE ボリューム、言語切替)
- 国際化 i18n (EN/JP 2言語)
- How-to-Play 画面

## Out of Scope
- BGM/SE の実際の音声ファイル実装 (設定 UI のみ)
- オンラインランキング
- ポーズメニュー (Phase 7.8 で実装済み)

# Expected Output
### 新規ファイル
- `lib/game/data/endless_data.dart` — Endless モード wave 生成 + 難易度計算
- `lib/game/data/achievements.dart` — 実績定義 + 条件判定ロジック
- `lib/game/components/debris.dart` — Debris コンポーネント
- `lib/game/components/boost_lane.dart` — Boost Lane コンポーネント
- `lib/screens/achievements_screen.dart` — 実績画面
- `lib/screens/endless_result_screen.dart` — Endless 専用リザルト
- `lib/screens/settings_screen.dart` — 設定画面
- `lib/screens/how_to_play_screen.dart` — How-to-Play 画面
- `lib/i18n/translations.dart` — EN/JP 翻訳辞書

### 変更ファイル
- `lib/game/data/constants.dart` — Debris/Boost Lane/Credit Boost 定数
- `lib/game/g_runner_game.dart` — Debris衝突, Boost Lane 判定, Endless対応
- `lib/game/data/stage_data.dart` — SpawnEventType に debris/boost_lane 追加
- `lib/data/game_progress.dart` — achievements, endlessBestTime/Score, creditBoostLevel, settings
- `lib/screens/title_screen.dart` — メニュー拡張 (Endless/Achievements/Settings/How-to-Play)
- `lib/screens/game_screen.dart` — Endless モード対応
- `lib/screens/upgrade_shop_screen.dart` — Credit Boost 追加
- `lib/screens/result_screen.dart` — 実績アンロック通知

# References
## RN版の関連ファイル
- `src/game/stages/endless.ts` — wave生成 (3+waveNum 敵種, 30秒/wave, gates毎2wave)
- `src/game/achievements.ts` — 10実績定義 + 条件
- `src/types/achievements.ts` — 型定義
- `src/engine/entities/Debris.ts` — Debris (HP50, 40×40, 接触20dmg)
- `src/engine/systems/BoostLaneSystem.ts` — Boost Lane (×1.5 score, ×1.3 scroll)
- `src/engine/systems/debrisDestroyReward.ts` — Debris撃破報酬 (+50pt)
- `src/game/upgrades.ts` — Credit Boost (+10%/Lv, 200×(Lv+1))
- `src/i18n/locales/en.ts`, `ja.ts` — 翻訳辞書
- `src/i18n/content/how-to-play.en.ts`, `ja.ts` — ゲーム説明

## 実装ノート
### Endless モード (RN版)
- 30秒/wave, waveNumber で敵種増加 (3+waveNum, 最大11種)
- 難易度: scrollSpeed +0.1/min, HP +0.3/min, ATK +0.15/min, 最大同時敵 6+2/min
- Gate: 奇数wave でゲートペア出現
- 保存: endlessBestTime, endlessBestScore

### 実績 (RN版)
| ID | 条件 | 報酬 |
|----|------|------|
| first_clear | 任意ステージクリア | 100 Cr |
| boss_slayer | ボス撃破 | 300 Cr |
| all_forms | 全フォームアンロック | 500 Cr |
| all_stages | 全15ステージクリア | 1000 Cr |
| no_damage_clear | ノーダメクリア | 500 Cr |
| combo_master | 覚醒発動 | 200 Cr |
| credit_hoarder | 10000 Cr 蓄積 | 300 Cr |
| speed_demon | HighSpeed でステージクリア | 200 Cr |
| guardian_angel | HP満タンでクリア | 200 Cr |
| endless_survivor | Endless 5分生存 | 500 Cr |

### Debris (RN版)
- HP: 50, サイズ: 40×40, 接触ダメージ: 20
- 撃破報酬: +50pt
- ステージイベント `debris_spawn(x, count)` で出現

### Boost Lane (RN版)
- ステージイベント `boost_lane_start(x, width)` / `boost_lane_end`
- 効果: スコア ×1.5, スクロール速度 ×1.3
- プレイヤーがレーン内にいる間のみ適用

### Credit Boost (RN版)
- +10%/Lv, max Lv5 (最大 +50%)
- コスト: 200 × (currentLevel + 1)
- ステージクリア時の獲得クレジットに乗算

### 設定 (RN版)
- BGM ボリューム: 0/0.25/0.5/0.75/1.0 (default 0.7)
- SE ボリューム: 同上 (default 1.0)
- 言語: System/English/日本語
- Haptics: ON/OFF (Flutter版では振動フィードバック)

# Design Notes
- Phase 12 と 13 はスコープが大きいため、dev-loop 内で複数イテレーションに分割する
  - Iteration 1: Endless モード (wave生成 + 専用 game flow)
  - Iteration 2: 実績システム + 実績画面
  - Iteration 3: Debris + Boost Lane コンポーネント
  - Iteration 4: Credit Boost + 設定画面
  - Iteration 5: i18n + How-to-Play
- Endless モードは StageData を動的に生成する方式 (generateEndlessWave)
- 実績チェックは GameProgress に集約し、ステージクリア / ボス撃破 / 購入時にトリガー
- i18n は軽量実装: Map<String, Map<String, String>> で EN/JP を管理
- BGM/SE は設定 UI のみ (実際のオーディオは将来対応)
