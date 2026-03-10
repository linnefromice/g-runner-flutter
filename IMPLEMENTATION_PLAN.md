# G-Runner Flutter - Implementation Plan

> RN版の2.5Dスクロールシューティングゲームを Flutter (Flame) で再現するプロトタイプ
> RN版参照: `../../g-runner-rn/` (11敵種, 7フォーム, 15ステージ+Endless, 3ボス)

## 現状サマリー (2026-03-11)

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

---

## 今後の実装ステップ

### Phase 2: 敵バリエーション + Stage 2
> ゲームの面白さに直結。新敵種を活かした Stage 2 タイムラインの充実が鍵。

- [ ] **2.1** Rush敵 (HP15, 射撃なし, 高速突進, 接触ダメージ)
  - 赤系の細い三角形、高速で画面下へ直進
  - 接触判定を衝突システムに追加
- [ ] **2.2** Swarm敵 (HP1, 群れ出現 3-5体同時)
  - 小型、射撃なし、スコア低め (50pt)
  - SpawnEvent に count パラメータ追加 or 複数 SpawnEvent で表現
- [ ] **2.3** Phalanx敵 (HP60, 前面シールド)
  - 上半分に当たった弾はダメージ半減 (シールド表現)
  - 下半分や側面からの攻撃は通常ダメージ
  - シールド部分の青い半透明エフェクト
- [ ] **2.4** Stage 2 タイムライン (90秒)
  - Act 1 前半の位置づけ: Stationary + Patrol に Rush, Swarm を混合
  - Wave構成: 序盤は Rush 単体 → 中盤 Swarm 群 → 終盤 Phalanx 登場
  - Gate: Enhance系 + Recovery を配置、難度に合わせた配分
- [ ] **2.5** Stage 3-4 タイムライン (各90秒)
  - Stage 3: Patrol + Phalanx 中心、Swarm wave を挟む
  - Stage 4: 全5種混合、高密度 wave、ボス前の総仕上げ

### Phase 3: コンボ & 覚醒 + EXバースト
> コンボ → 覚醒と EX を同時に入れてゲーム体験の統一感を出す。
> Tradeoff Gate はフォームシステムに絡むため Phase 4 に移動。

- [ ] **3.1** コンボゲージ (3段階)
  - Enhance/Recovery Gate 通過でコンボ+1
  - 被ダメージでコンボリセット
  - HUD にコンボゲージ表示 (3セグメント)
- [ ] **3.2** 覚醒フォーム発動 (コンボ3で自動発動)
  - 10秒間の強化状態
  - ATK 2.0倍, Speed 1.2倍, FireRate 1.3倍
  - 追尾弾 (敵方向に緩やかにホーミング)
  - 無敵状態 (被弾しない)
  - 専用ビジュアル (金色オーラ)
- [ ] **3.3** 覚醒タイマー HUD 表示
  - 覚醒中は残り時間をバー表示
  - 終了時にコンボリセット
- [ ] **3.4** EXゲージ (max 100)
  - 敵撃破 +5, Gate通過 +10, ボス攻撃 +2
  - HUD にゲージバー表示
- [ ] **3.5** EXバースト発動
  - ゲージ満タンでタップ発動 (専用ボタン or ダブルタップ)
  - 全画面攻撃: 画面内の全敵に50ダメージ
  - 2秒間の持続ダメージゾーン
  - 発動時にゲージ0にリセット

### Phase 4: フォーム & Transform システム
> フォーム切替、Tradeoff Gate、特殊弾種で戦略性を付与。

- [ ] **4.1** フォーム定義 (Standard, Heavy Artillery, High Speed)
  - Standard: バランス型 (ATK 1.0, SPD 1.0, FR 1.0)
  - Heavy Artillery: 重火力 (ATK 1.8, SPD 0.8, FR 0.6) + 爆発弾
  - High Speed: 高速型 (ATK 0.7, SPD 1.4, FR 1.5) + 貫通弾
- [ ] **4.2** Transformゲージ (max 100)
  - 敵撃破 +8, Gate通過 +12, 時間経過 +2/s
  - HUD にゲージ + TFボタン表示
- [ ] **4.3** フォーム切替メカニクス
  - Primary / Secondary のフォーム選択 (ステージ開始前)
  - TFボタンで切替、ゲージ消費
  - 切替後5秒間のバフ (ATK 1.25倍, SPD 1.15倍)
- [ ] **4.4** Tradeoff Gate
  - 左右で異なるトレードオフ効果 (例: ATK↑ SPD↓ vs SPD↑ ATK↓)
  - コンボリセット
  - 黄色表示で Enhance Gate と区別
- [ ] **4.5** 特殊弾種
  - Heavy Artillery: 爆発弾 (着弾時40px範囲ダメージ)
  - High Speed: 貫通弾 (敵を貫通して複数ヒット)

### Phase 5: ボスステージ (Act 1 完結)
> Stage 5 にボスを配置し、Stage 1-5 で Act 1 として一区切り。

- [ ] **5.1** Boss エンティティ
  - HP 500, 画面上部でホバー移動 (振幅30px, 周期3s)
  - 専用ビジュアル (大型、多角形)
  - HPバー (画面上部に専用表示)
- [ ] **5.2** Boss 攻撃パターン
  - Phase 1 (HP 100-66%): 5方向弾 (15° 間隔)
  - Phase 2 (HP 66-33%): 弾速UP + 発射間隔短縮
  - Phase 3 (HP 33-0%): ドローン召喚 (3体)
- [ ] **5.3** Boss Phase ゲームルール
  - スクロール速度 0.5倍
  - 通常敵/Gate スポーン停止
  - ボス撃破でステージクリア
- [ ] **5.4** Stage 5 タイムライン (180秒)
  - 前半: 通常 wave (ボス前の高難度構成)
  - 後半 (80%経過時): ボス出現

### Phase 6: メタゲーム
> ステージ選択、通貨、アップグレードで周回プレイの動機付け。

- [ ] **6.1** ステージ選択画面
  - クリア済みステージの表示
  - ハイスコア表示
  - 次ステージのアンロック
- [ ] **6.2** フォーム選択画面 (ステージ開始前)
  - Primary / Secondary フォーム選択
  - フォーム毎のステータス表示
- [ ] **6.3** クレジット (通貨) システム
  - 敵撃破 1-3 Cr, ステージクリア 50 Cr, ボス撃破 150 Cr
- [ ] **6.4** アップグレードショップ
  - ATK +2/Lv (max 10), HP +10/Lv (max 10)
  - Speed +5%/Lv (max 5), DEF +3%/Lv (max 5)
  - コスト: 100 × (Lv+1)
- [ ] **6.5** セーブデータ永続化 (shared_preferences)
  - ハイスコア, アンロック済みステージ/フォーム, アップグレード, クレジット

### Phase 7: 追加コンテンツ & ポリッシュ (将来)
> Act 1 完成後に検討。

- [ ] 追加敵種 (Dodger, Splitter, Summoner, Sentinel, Juggernaut, Carrier)
- [ ] Stage 6-10 + Boss 2
- [ ] 追加フォーム (Sniper, Scatter, Guardian)
- [ ] Graze メカニクス (3段階ニアミス判定)
- [ ] Parry / Just Transform (変身タイミングで被弾無効化 + 衝撃波)
- [ ] フォームXP & スキルツリー
- [ ] Refit Gate / Growth Gate / Roulette Gate
- [ ] Debris システム (破壊可能障害物)
- [ ] 実績システム
- [ ] Endless モード
- [ ] Stage 11-15 + Boss 3

---

## マイルストーン

| マイルストーン | Phase | 内容 |
|-------------|-------|------|
| **MVP** | 0-1 ✅ | Stage 1 プレイ可能、基本ゲーム体験 |
| **Alpha** | 2-3 | 5敵種、コンボ/覚醒/EX、Stage 1-4 |
| **Act 1 Complete** | 4-5 | フォーム切替、ボス戦、Stage 1-5 |
| **Full Loop** | 6 | メタゲーム周回が成立 |
| **Content Complete** | 7 | RN版の主要機能を網羅 |

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

## 参照
- RN版: `../../g-runner-rn/`
- RN版 CLAUDE.md: `../../g-runner-rn/CLAUDE.md`
- RN版 バランス定数: `../../g-runner-rn/src/constants/balance.ts`
