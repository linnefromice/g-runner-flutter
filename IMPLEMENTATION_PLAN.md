# G-Runner Flutter - Implementation Plan

> RN版の2.5Dスクロールシューティングゲームを Flutter (Flame) で再現するプロトタイプ
> RN版参照: `../../g-runner-rn/` (11敵種, 7フォーム, 15ステージ+Endless, 3ボス)

## 現状サマリー (2026-03-11 updated — Phase 0-13 完了)

### 完了済み (Phase 0: Core Prototype)
- [x] Flame ゲームエンジン基盤 (`GRunnerGame`)
- [x] 論理座標系 (320px幅, アスペクト比自動)
- [x] Player (ドラッグ移動, タップ移動, 自動射撃 0.2s間隔)
- [x] Player I-frame (1.2s, 点滅表示)
- [x] Enemy: Stationary (HP20, 2s射撃)
- [x] Enemy: Patrol (HP40, 2.5s射撃, 横移動, 照準弾)
- [x] Enemy 2.5D深度スケーリング
- [x] Enemy ヒットフラッシュ (白, 0.1s)
- [x] Enemy HPバー表示
- [x] PlayerBullet / EnemyBullet
- [x] Gate (ATK加算, Speed倍率, HP回復) 左右ペア出現
- [x] Parallax 3層背景 + スキャンライン
- [x] Kill パーティクル (8方向放射)
- [x] HUD (HP, Score, ステージ進捗バー)
- [x] 衝突判定 (AABB)
- [x] Stage 1 タイムライン (60秒, 5wave + 3gate)
- [x] Title / Game / Result 画面
- [x] GameState (playing / gameOver / stageClear)

### 完了済み (Phase 1: ゲーム体験の改善) ✅
- [x] **1.1** スクリーンシェイク (被ダメ時/敵撃破時)
- [x] **1.2** スコアポップアップ (敵撃破/Gate通過時にスコアをその場に表示)
- [x] **1.3** 敵の弾を照準型に (Patrol敵がPlayer方向に発射)
- [x] **1.4** Gateエフェクト追加: HP回復 (`hpRecover`)
- [x] **1.5** ステージタイマーHUD表示 (残り時間プログレスバー)

### 完了済み (Phase 2: 敵バリエーション + Stage 2-4) ✅
- [x] Rush敵 (HP15, 高速突進+追尾, 接触ダメージ)
- [x] Swarm敵 (HP1, 正弦波横揺れ, 群れ出現)
- [x] Phalanx敵 (HP60, 3方向弾, 上半分シールド)
- [x] Stage 2-4 タイムライン (各90秒)

### 完了済み (Phase 3: コンボ & 覚醒 + EXバースト) ✅
- [x] コンボゲージ (3段階, Gate通過+1, 被ダメリセット)
- [x] 覚醒フォーム (コンボ3自動発動, 10秒, ATK2x/SPD1.2x/FR1.3x, 無敵, 金色オーラ)
- [x] 覚醒タイマー HUD (残り3秒で赤色警告)
- [x] EXゲージ (max100, 敵撃破+5/Gate+10)
- [x] EXバースト (ビーム80u幅, 2秒間, 50dmg/tick, 敵弾消滅)

### 完了済み (Phase 4: フォーム & Transform) ✅
- [x] フォーム定義 (Standard/Heavy Artillery/High Speed)
- [x] Transformゲージ (max100, 敵撃破+8/Gate+12/時間+2/s)
- [x] フォーム切替 (TFボタン, 5秒バフ, 覚醒中は不可)
- [x] Tradeoff Gate (黄色, 双方向効果, EXバーストで破壊可能)
- [x] 特殊弾種 (爆発弾40px AoE, 貫通弾)

---

## 今後の実装ステップ

### Phase 2: 敵バリエーション + Stage 2
> ゲームの面白さに直結。新敵種を活かした Stage 2 タイムラインの充実が鍵。

- [x] **2.1** Rush敵 (HP15, 射撃なし, 高速突進, 接触ダメージ)
  - 赤系の細い三角形、高速で画面下へ直進
  - 接触判定を衝突システムに追加
- [x] **2.2** Swarm敵 (HP1, 群れ出現 3-5体同時)
  - 小型、射撃なし、スコア低め (30pt)
  - 複数 SpawnEvent で表現
- [x] **2.3** Phalanx敵 (HP60, 前面シールド)
  - 上半分に当たった弾はダメージ半減 (シールド表現)
  - 下半分や側面からの攻撃は通常ダメージ
  - シールド部分の青い半透明エフェクト
- [x] **2.4** Stage 2 タイムライン (90秒)
  - Act 1 前半の位置づけ: Stationary + Patrol に Rush, Swarm を混合
  - Wave構成: 序盤は Rush 単体 → 中盤 Swarm 群 → 終盤 Phalanx 登場
  - Gate: Enhance系 + Recovery を配置、難度に合わせた配分
- [x] **2.5** Stage 3-4 タイムライン (各90秒)
  - Stage 3: Patrol + Phalanx 中心、Swarm wave を挟む
  - Stage 4: 全5種混合、高密度 wave、ボス前の総仕上げ

### Phase 3: コンボ & 覚醒 + EXバースト
> コンボ → 覚醒と EX を同時に入れてゲーム体験の統一感を出す。
> Tradeoff Gate はフォームシステムに絡むため Phase 4 に移動。

- [x] **3.1** コンボゲージ (3段階)
  - Enhance/Recovery Gate 通過でコンボ+1
  - 被ダメージでコンボリセット
  - HUD にコンボゲージ表示 (3セグメント)
- [x] **3.2** 覚醒フォーム発動 (コンボ3で自動発動)
  - 10秒間の強化状態
  - ATK 2.0倍, Speed 1.2倍, FireRate 1.3倍
  - 無敵状態 (被弾しない)
  - 専用ビジュアル (金色オーラ)
  - 発動時スローモーション (0.3x, 300ms)
- [x] **3.3** 覚醒タイマー HUD 表示
  - 覚醒中は残り時間をバー表示
  - 残り3秒で警告表示 (赤色)
  - 終了時にコンボリセット
- [x] **3.4** EXゲージ (max 100)
  - 敵撃破 +5, Gate通過 +10, ボス攻撃 +2
  - HUD にゲージバー表示
- [x] **3.5** EXバースト発動
  - ゲージ満タンでタップ発動 (専用ボタン)
  - 全画面ビーム: 幅80u、上方向、50dmg/100msティック
  - 2秒間の持続ダメージゾーン
  - 敵弾消滅 + Tradeoff Gate 破壊
  - 発動時にゲージ0にリセット

### Phase 4: フォーム & Transform システム
> フォーム切替、Tradeoff Gate、特殊弾種で戦略性を付与。

- [x] **4.1** フォーム定義 (Standard, Heavy Artillery, High Speed)
  - Standard: バランス型 (ATK 1.0, SPD 1.0, FR 1.0)
  - Heavy Artillery: 重火力 (ATK 1.8, SPD 0.8, FR 0.6) + 爆発弾
  - High Speed: 高速型 (ATK 0.7, SPD 1.4, FR 1.5) + 貫通弾
- [x] **4.2** Transformゲージ (max 100)
  - 敵撃破 +8, Gate通過 +12, 時間経過 +2/s
  - HUD にゲージ + TFボタン表示
- [x] **4.3** フォーム切替メカニクス
  - Primary / Secondary のフォーム (デフォルト: Standard / Heavy Artillery)
  - TFボタンで切替、ゲージ消費
  - 切替後5秒間のバフ (ATK 1.25倍, SPD 1.15倍, FR 1.2倍, HP+5)
  - 覚醒中はTransform不可
- [x] **4.4** Tradeoff Gate
  - 左右で異なるトレードオフ効果 (ATK↑SPD↓ / SPD↑ATK↓)
  - 黄色表示で Enhance Gate と区別
  - EXバーストで破壊可能
- [x] **4.5** 特殊弾種
  - Heavy Artillery: 爆発弾 (着弾時40px範囲ダメージ)
  - High Speed: 貫通弾 (敵を貫通して複数ヒット)
  - 弾のサイズ・速度・色がフォームに連動

### 完了済み (Phase 5: ボスステージ — Act 1 完結) ✅
- [x] **5.1** Boss エンティティ
  - HP 500, 画面上部でホバー移動 (振幅30px, 周期3s)
  - 専用ビジュアル (大型、多角形)
  - HPバー (画面上部に専用表示、フェーズ色変化)
- [x] **5.2** Boss 攻撃パターン
  - Phase 1 (HP 100-66%): 5方向弾 (15° 間隔)
  - Phase 2 (HP 66-33%): 弾速UP + 発射間隔短縮
  - Phase 3 (HP 33-0%): ドローン召喚 (3体)
- [x] **5.3** Boss Phase ゲームルール
  - スクロール速度 0.5倍
  - 通常敵/Gate スポーン停止
  - ボス撃破でステージクリア
- [x] **5.4** Stage 5 タイムライン (180秒)
  - 前半: 通常 wave (ボス前の高難度構成)
  - 62秒時: ボス出現

### 完了済み (Phase 6: メタゲーム) ✅
- [x] **6.1** ステージ選択画面
  - クリア済みステージの表示
  - ハイスコア表示
  - 次ステージのアンロック
- [x] **6.2** フォーム選択画面 (ステージ開始前)
  - Primary / Secondary フォーム選択
  - フォーム毎のステータス表示
- [x] **6.3** クレジット (通貨) システム
  - 敵撃破 1-3 Cr, ステージクリア 50 Cr, ボス撃破 150 Cr
- [x] **6.4** アップグレードショップ
  - ATK +2/Lv (max 10), HP +10/Lv (max 10)
  - Speed +5%/Lv (max 5), DEF +3%/Lv (max 5)
  - コスト: baseCost × (Lv+1)
- [x] **6.5** セーブデータ永続化 (shared_preferences)
  - ハイスコア, アンロック済みステージ/フォーム, アップグレード, クレジット

### 完了済み (Phase 7: Boss 強化 + 新敵種 + ポーズ) ✅
> Act 2 のステージに必要な敵種を追加し、Boss にレーザー攻撃パターンを実装。ポーズ機能も追加。

- [x] **7.1** Boss レーザー攻撃パターン
  - 警告フェーズ (1000ms) → 照射フェーズ (1500ms)
  - レーザー幅 30px、20dmg/tick
  - Phase 1: スプレッド → Phase 2: スプレッド + レーザー交互
  - Boss 2/3 で使用
- [x] **7.2** Juggernaut敵 (HP120, ATK25, 低速、高耐久)
  - 大型六角形、ゆっくり降下、3砲塔ラウンドロビン射撃
  - 正弦波横移動
- [x] **7.3** Dodger敵 (回避パターン)
  - プレイヤー弾に反応して横に回避
  - 回避後に照準射撃
- [x] **7.4** Splitter敵 (分裂)
  - 撃破時に3体の Swarm に分裂
  - 分裂体は Swarm 相当の HP1
- [x] **7.5** Summoner敵 (召喚)
  - 一定間隔で Swarm ペアを召喚 (最大6体)
  - 本体を倒さないと Swarm が増え続ける
- [x] **7.6** Sentinel敵 (盾役)
  - 全ダメージ 50% 軽減シールド
  - 3方向スプレッド射撃
- [x] **7.7** Carrier敵 (搬送)
  - ゆっくり降下 + 横パトロール
  - 一定間隔で Patrol 敵ペアを搬出
- [x] **7.8** ポーズ機能
  - HUD にポーズボタン追加
  - ポーズオーバーレイ (Resume / Exit)
  - GameState.paused 追加
- [x] **7.9** スコア/クレジット拡張
  - 新敵種のスコア/クレジット値追加
  - Splitter 撃破時の Swarm スポーンロジック

### 完了済み (Phase 8: Act 2 — Stage 6-10 + Boss 2) ✅
> 新敵種を活かした Act 2 ステージ群と Boss 2。

- [x] **8.1** 難易度スケーリングシステム
  - DifficultyParams: ステージ ID ベースの動的調整
  - スクロール速度, 敵HP/ATK, 弾速, 発射間隔をステージごとにスケール
- [x] **8.2** Stage 6-9 タイムライン
  - Stage 6 (100s): Scrap Yard — Swarm 大群
  - Stage 7 (110s): Fortress Gate — Phalanx 壁
  - Stage 8 (120s): War Front — Juggernaut + Sentinel
  - Stage 9 (130s): Final Approach — 全敵種 + Carrier
- [x] **8.3** Stage 10 タイムライン (180秒, Boss 2)
  - Boss 2: HP 750, ドローン 4, 早期フェーズ遷移
  - 前半: 高密度 wave (Juggernaut + Sentinel + Dodger)
- [x] **8.4** Boss バリアント対応
  - Boss(bossIndex) — HP/ドローン数/フェーズ閾値がスケール
  - Boss 2: phase2=75%, phase3=50%

### 完了済み (Phase 9: 追加フォーム & Gate 拡張) ✅
> 戦略の幅を広げるフォームと Gate 種別。

- [x] **9.1** Sniper フォーム (SPD 0.6x, ATK 2.5x, FR 0.3x)
  - BulletType.shieldPierce — Phalanx/Sentinel のシールド無視
  - 弾速 600, 長い弾ビジュアル
- [x] **9.2** Scatter フォーム (SPD 1.0x, ATK 0.6x, FR 1.0x)
  - 5方向同時発射 (±20° 扇状)
- [x] **9.3** Guardian フォーム (SPD 0.7x, ATK 0.8x, FR 0.8x)
  - 被ダメージ 20%軽減 (defMultiplier に加算)
- [x] **9.4** フォームアンロック (クレジット購入)
  - Sniper: Stage 7 + 800 Cr, Scatter: Stage 8 + 800 Cr, Guardian: Stage 10 + 1000 Cr
  - FormSelectScreen にロック/アンロック/購入 UI
- [x] **9.5** Refit Gate (フォーム変更)
  - GateEffectType.refit — value=FormType index
  - 紫色表示、ラベル「→ Heavy」等
- [x] **9.6** Growth Gate (累積強化)
  - GateEffectType.growth — ATK +value
  - 緑色表示
- [x] **9.7** Roulette Gate (ランダム)
  - GateEffectType.roulette — 50/50 で ATK +value or +value2
  - マゼンタ色表示

### 完了済み (Phase 10: Act 3 — Stage 11-15 + Boss 3) ✅
> 最終ステージ群とラスボス。

- [x] **10.1** Stage 11-14 タイムライン
  - Stage 11 (110s): Phantom Zone — Dodger 重点
  - Stage 12 (120s): Hive Cluster — Splitter 連鎖分裂
  - Stage 13 (120s): Command Nexus — Summoner + Phalanx 要塞
  - Stage 14 (130s): Chaos Corridor — 全敵種混合
- [x] **10.2** Stage 15 タイムライン (180秒, Boss 3)
  - Boss 3: HP 1000, ドローン 5体, レーザー幅 40px, ホーミング弾 2発
  - 前半: 高密度ガントレット → t=65 でボス出現
- [x] **10.3** ステージクリアボーナス
  - ノーダメージ: Score ×1.5, Credit ×2.0
  - コンボ: 覚醒回数 × 500pt
  - フルクリア: 全敵撃破 +1000pt
  - スピード: 残り時間 × 10pt (非ボスのみ)
  - Result 画面にボーナス内訳表示

### 完了済み (Phase 11: フォームスキルツリー & 上級メカニクス) ✅
> フォーム育成と高度な操作系。

- [x] **11.1** フォーム XP システム
  - 敵撃破+5, 強敵+10, Gate通過+8, Graze+3/6/15
  - Lv1=50, Lv2=200, Lv3=500 (累計XP)
  - GameProgress に formXp/formSkills 永続化
- [x] **11.2** スキルツリーデータ定義
  - 6フォーム × 3レベル × A/B 二択 = 36スキル枠
  - 18パッシブスキル enum 定義
  - ResolvedFormSkills でスキル効果集約
  - (パッシブスキルの実行時適用は後続イテレーションで追加)
- [x] **11.3** Graze メカニクス
  - 3段階判定: normal (+20pt/+3EX), close (+50pt/+6EX), extreme (+150pt/+12EX)
  - HUD に Graze カウンター表示
  - Form XP 獲得源として統合
- [x] **11.4** Parry / Just Transform
  - Transform 発動後 200ms 窓で被弾→無効化
  - 半径60の衝撃波 (30ダメージ) + 範囲内弾消し
  - +300pt, +15EX, 画面シェイク

### 完了済み (Phase 12: Endless モード + 実績) ✅
> リプレイ性の最終ピース。

- [x] **12.1** Endless モード
  - 動的 wave 生成 (30秒/wave, 敵種漸増, Gate 毎2wave)
  - 時間ベース難易度スケーリング (scroll +0.1/min, HP +0.3/min, ATK +0.15/min)
  - ベストスコア/ベストタイム永続化
  - 専用リザルト画面 (スコア/タイム/ウェーブ)
  - タイトル画面に ENDLESS メニュー追加
- [x] **12.2** 実績システム (10種)
  - first_clear (初クリア, 100 Cr)
  - boss_slayer (ボス撃破, 300 Cr)
  - all_forms (全フォームアンロック, 500 Cr)
  - all_stages (全15ステージクリア, 1000 Cr)
  - no_damage_clear (ノーダメージクリア, 500 Cr)
  - combo_master (覚醒発動, 200 Cr)
  - credit_hoarder (10000 Cr 蓄積, 300 Cr)
  - speed_demon (HighSpeed でクリア, 200 Cr)
  - guardian_angel (HP満タンでクリア, 200 Cr)
  - endless_survivor (Endless 5分生存, 500 Cr)
  - ステージクリア/ゲームオーバー時に自動チェック
- [x] **12.3** 実績画面
  - 達成/未達成リスト (アイコン+説明+報酬)
  - 報酬クレジット受取 (CLAIM ボタン)
  - タイトル画面に ACHIEVEMENTS メニュー追加

### 完了済み (Phase 13: UX ポリッシュ) ✅
> ゲーム体験の完成度を上げる各種機能。

- [x] **13.1** ポーズメニュー (Phase 7.8 で実装済み)
- [x] **13.2** Debris システム (破壊可能障害物)
  - HP 50, サイズ 40×40, 接触ダメージ 20
  - 撃破報酬 +50pt, +1 Cr
  - SpawnEvent.debris で出現
- [x] **13.3** Boost Lane (スコアブースト帯)
  - SpawnEvent.boostLaneStart/End で出現・消滅
  - レーン内滞在でスコア ×1.5, スクロール ×1.3
  - 視覚エフェクト (脈動、シェブロンアニメーション)
- [x] **13.4** Credit Boost アップグレード
  - +10%/Lv (max 5), コスト 200 × (Lv+1)
  - アップグレードショップに追加
  - ステージクリア時の獲得クレジットに乗算
- [x] **13.5** 設定画面
  - BGM/SE ボリュームスライダー (0-100%)
  - 言語切替 (System/English/日本語)
  - タイトル画面に SETTINGS メニュー追加
- [x] **13.6** 国際化 (i18n)
  - EN/JP 翻訳辞書 (lib/i18n/translations.dart)
  - UI ラベル、フォーム名、How-to-Play 等
  - tr() 関数による軽量翻訳
- [x] **13.7** How-to-Play 画面
  - 6セクション: Controls, Gates, Combo, Transform, Combat, Forms
  - i18n 対応 (EN/JP)
  - タイトル画面に HOW TO PLAY メニュー追加

---

## マイルストーン

| マイルストーン | Phase | 内容 |
|-------------|-------|------|
| **MVP** | 0-1 ✅ | Stage 1 プレイ可能、基本ゲーム体験 |
| **Alpha** | 2-3 ✅ | 5敵種、コンボ/覚醒/EX、Stage 1-4 |
| **Act 1 Complete** | 4-5 ✅ | フォーム切替、ボス戦、Stage 1-5 |
| **Full Loop** | 6 ✅ | メタゲーム周回が成立 |
| **Act 2 Ready** | 7 ✅ | Boss レーザー + 6新敵種 |
| **Act 2 Complete** | 8 ✅ | Stage 6-10 + Boss 2、難易度スケーリング |
| **Full Arsenal** | 9 ✅ | 6フォーム + 全Gate種 |
| **Act 3 Complete** | 10 ✅ | Stage 11-15 + Boss 3、全ステージ完備 |
| **Deep Mechanics** | 11 ✅ | スキルツリー + Graze + Parry |
| **Replay Complete** | 12 ✅ | Endless + 実績、リプレイ性完成 |
| **Content Complete** | 13 ✅ | RN版の全機能を網羅 |

---

## アーキテクチャメモ

```
lib/
├── main.dart
├── game/
│   ├── g_runner_game.dart       # Flame GameEngine
│   ├── components/              # ゲームエンティティ (Player, Enemy, Bullet, etc.)
│   ├── data/                    # 定数, ステージ定義
│   ├── systems/                 # (予約: 分離が必要になった時)
│   └── ui/                      # HUD overlay
└── screens/                     # Flutter Widget 画面
```

## RN版との機能比較

| 機能カテゴリ | RN版 | Flutter版 (現在) | 差分 Phase |
|------------|------|-----------------|-----------|
| 敵種 | 11 (stationary〜carrier) | 5 (stationary〜phalanx) | Phase 7 |
| フォーム | 7 (Standard〜Awakened) | 3 (Standard/Heavy/HighSpeed) | Phase 9 |
| ボス | 3 (Stage 5/10/15) | 1 (Stage 5) | Phase 8, 10 |
| ボス攻撃 | スプレッド + レーザー + ドローン | スプレッド + ドローン | Phase 7 |
| ステージ | 15 + Endless | 5 | Phase 8, 10, 12 |
| Gate 種別 | 6 (enhance〜roulette) | 3 (enhance/tradeoff/recovery) | Phase 9 |
| スキルツリー | 3Lv × 2択/フォーム、19パッシブ | なし | Phase 11 |
| 難易度スケーリング | ステージ毎自動調整 | なし | Phase 8 |
| 実績 | 10種 | なし | Phase 12 |
| Endless モード | あり | なし | Phase 12 |
| ポーズ | あり | なし | Phase 13 |
| 設定 (音量/言語) | あり | なし | Phase 13 |
| i18n (EN/JP) | あり | なし | Phase 13 |
| Debris | あり | なし | Phase 13 |
| Boost Lane | あり | なし | Phase 13 |
| クリアボーナス | 4種 | なし | Phase 10 |
| Graze | あり | なし | Phase 11 |
| Credit Boost | あり | なし | Phase 13 |

## 参照
- RN版: `../../g-runner-rn/`
- RN版 CLAUDE.md: `../../g-runner-rn/CLAUDE.md`
- RN版 バランス定数: `../../g-runner-rn/src/constants/balance.ts`
