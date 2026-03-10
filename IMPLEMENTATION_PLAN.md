# G-Runner Flutter - Implementation Plan

> RN版の2.5Dスクロールシューティングゲームを Flutter (Flame) で再現するプロトタイプ

## 現状サマリー (2026-03-10)

### 完了済み (Phase 0: Core Prototype)
- [x] Flame ゲームエンジン基盤 (`GRunnerGame`)
- [x] 論理座標系 (320px幅, アスペクト比自動)
- [x] Player (ドラッグ移動, タップ移動, 自動射撃 0.2s間隔)
- [x] Player I-frame (1.2s, 点滅表示)
- [x] Enemy: Stationary (HP20, 2s射撃)
- [x] Enemy: Patrol (HP40, 2.5s射撃, 横移動)
- [x] Enemy 2.5D深度スケーリング
- [x] Enemy ヒットフラッシュ (白, 0.1s)
- [x] Enemy HPバー表示
- [x] PlayerBullet / EnemyBullet
- [x] Gate (ATK加算, Speed倍率) 左右ペア出現
- [x] Parallax 3層背景 + スキャンライン
- [x] Kill パーティクル (8方向放射)
- [x] HUD (HP, Score)
- [x] 衝突判定 (AABB)
- [x] Stage 1 タイムライン (60秒, 5wave + 3gate)
- [x] Title / Game / Result 画面
- [x] GameState (playing / gameOver / stageClear)

**現状: ステージ1が遊べる最低限のプロトタイプとして動作**

---

## 今後の実装ステップ

### Phase 1: ゲーム体験の改善 ✅
- [x] **1.1** スクリーンシェイク (被ダメ時/敵撃破時)
- [x] **1.2** スコアポップアップ (敵撃破/Gate通過時にスコアをその場に表示)
- [x] **1.3** 敵の弾を照準型に (Patrol敵がPlayer方向に発射)
- [x] **1.4** Gateエフェクト追加: HP回復 (`hpRecover`)
- [x] **1.5** ステージタイマーHUD表示 (残り時間プログレスバー)

### Phase 2: 敵バリエーション追加
- [ ] **2.1** Rush敵 (HP15, 射撃なし, 高速突進)
- [ ] **2.2** Swarm敵 (HP1, 群れ出現)
- [ ] **2.3** Phalanx敵 (HP60, 前面シールド)
- [ ] **2.4** Stage 2 タイムラインデータ作成

### Phase 3: コンボ & フォームシステム
- [ ] **3.1** コンボゲージ (3段階, HUD表示)
- [ ] **3.2** Enhance Gate連続3回で覚醒フォーム発動
- [ ] **3.3** 覚醒フォーム (10秒, ATK2倍, 追尾弾, 無敵)
- [ ] **3.4** Tradeoff Gate (ATK↔Speed トレードオフ)

### Phase 4: EX & Transform
- [ ] **4.1** EXゲージ (敵撃破+5, Gate+10, max100)
- [ ] **4.2** EXバースト (全画面攻撃)
- [ ] **4.3** Transformゲージ + フォーム切替ボタン
- [ ] **4.4** フォーム2種定義 (Standard, Heavy Artillery)

### Phase 5: ボスステージ
- [ ] **5.1** Boss エンティティ (HP500, ホバー移動)
- [ ] **5.2** Boss 攻撃パターン (5方向弾)
- [ ] **5.3** Boss Phase (スクロール0.5倍, 敵スポーン停止)
- [ ] **5.4** Stage 5 (Boss) タイムライン

### Phase 6: メタゲーム
- [ ] **6.1** ステージ選択画面
- [ ] **6.2** クレジット (通貨) システム
- [ ] **6.3** アップグレードショップ (ATK, HP, Speed, DEF)
- [ ] **6.4** セーブデータ永続化 (shared_preferences)

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
