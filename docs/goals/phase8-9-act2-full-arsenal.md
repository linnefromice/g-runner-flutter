# Goal
Act 2 の完全実装: 難易度スケーリング、Stage 6-10 + Boss 2、新フォーム3種 (Sniper/Scatter/Guardian)、
Gate 拡張 (Refit/Growth/Roulette)、フォームアンロックシステムを実装し、Act 2 の周回ループを完成させる。

# Context
- Phase 0-7 完了: 11敵種、Boss 1 (レーザー付き)、3フォーム、メタゲーム (ショップ/セーブ)、ポーズ機能が実装済み
- IMPLEMENTATION_PLAN.md の Phase 8 + Phase 9 に該当
- マイルストーン: 「Act 2 Complete」+「Full Arsenal」を同時達成
- RN版では Stage 6-10 が Act 2、フォーム7種中6種が Act 2 までに登場

# Scope
## In Scope
- 難易度スケーリングシステム (ステージID ベースの動的調整)
- Stage 6-9 タイムライン (各120秒、新敵種を段階的に投入)
- Stage 10 タイムライン (180秒、Boss 2)
- Boss バリアント (bossIndex パラメータ、HP/ドローン数/フェーズ閾値スケール)
- Sniper フォーム (ATK 2.5x, FR 0.3x, シールド貫通)
- Scatter フォーム (ATK 0.6x, FR 1.0x, 5方向同時発射)
- Guardian フォーム (ATK 0.8x, FR 0.8x, 被ダメ 20%軽減)
- フォームアンロック (ステージクリア + クレジット条件)
- フォーム選択画面のロック/アンロック表示
- Refit Gate (フォーム強制変更)
- Growth Gate (累積強化)
- Roulette Gate (ランダム効果)

## Out of Scope
- Stage 11-15 / Boss 3 (Phase 10)
- フォームスキルツリー (Phase 11)
- Graze / Parry メカニクス (Phase 11)
- Boost Lane / Debris (Phase 13)
- ステージクリアボーナス (Phase 10)
- Endless モード (Phase 12)

# Expected Output

## データ定義
- `lib/game/data/constants.dart` — 難易度スケーリング定数、新フォーム定義、新Gate定数
- `lib/game/data/stage_data.dart` — 新 GateEffectType (refit, growth, roulette)
- `lib/game/data/stage6_data.dart` 〜 `stage10_data.dart` — 各ステージタイムライン
- `lib/game/data/stages.dart` — Stage 6-10 登録

## コンポーネント
- `lib/game/components/boss.dart` — Boss バリアント対応 (bossIndex)
- `lib/game/components/gate.dart` — Refit/Growth/Roulette Gate の表示・エフェクト
- `lib/game/components/player.dart` — Scatter 5方向発射、Sniper シールド貫通、Guardian 被ダメ軽減

## ゲームエンジン
- `lib/game/g_runner_game.dart` — 難易度スケーリング適用、新 Gate 効果処理、フォーム強制変更
- `lib/game/data/difficulty.dart` — (新規) 難易度計算ヘルパー

## メタゲーム
- `lib/data/game_progress.dart` — フォームアンロック状態の永続化
- `lib/screens/form_select_screen.dart` — ロック/アンロック表示、購入UI

# References
## RN版の関連ファイル
- `src/game/difficulty.ts` — 難易度スケーリング計算式
- `src/game/stages/stage6.ts` 〜 `stage10.ts` — Stage 6-10 タイムライン
- `src/game/forms.ts` — 7フォーム定義 (Sniper/Scatter/Guardian)
- `src/game/gates.ts` — 全Gate定義 (Refit/Growth/Roulette含む)
- `src/game/upgrades.ts` — フォームアンロック条件
- `src/engine/systems/bossPhase.ts` — Boss フェーズ遷移 (バリアント差分)
- `src/constants/balance.ts` — 全バランス定数

## 実装ノート

### 難易度スケーリング (RN版 difficulty.ts)
```
scrollSpeedMultiplier: 1.0 + (stageId - 1) * 0.06
enemyHpMultiplier: 1.0 + (stageId - 1) * 0.12
enemyAtkMultiplier: 1.0 + (stageId - 1) * 0.08
bulletSpeedMultiplier: 1.0 + (stageId - 1) * 0.05
attackIntervalMultiplier: max(0.6, 1.0 - (stageId - 1) * 0.04)
maxConcurrentEnemies: min(7, 2 + floor(stageId / 2))
```

### Boss バリアント
- Boss 1: HP 500, ドローン 3, phase2=66%, phase3=33%
- Boss 2: HP 750, ドローン 4, phase2=75%, phase3=50% (早期遷移)
- Boss 3: HP 1000, ドローン 5, レーザー幅拡大

### 新フォーム定義 (RN版 forms.ts)
| Form | Speed | ATK | FR | 特殊能力 | 弾速 |
|------|-------|-----|----|---------|------|
| Sniper | 0.6 | 2.5 | 0.3 | シールド貫通 | 600 |
| Scatter | 1.0 | 0.6 | 1.0 | 5方向発射 | 380 |
| Guardian | 0.7 | 0.8 | 0.8 | 被ダメ-20% | 400 |

### フォームアンロック条件 (RN版 upgrades.ts)
- Standard: 初期
- Heavy Artillery: Stage 3 + 500 Cr
- High Speed: Stage 5 + 500 Cr
- Sniper: Stage 7 + 800 Cr
- Scatter: Stage 8 + 800 Cr
- Guardian: Stage 10 + 1000 Cr

### 新 Gate 種別 (RN版 gates.ts)
- **Refit Gate**: フォーム強制変更 (→Heavy, →Speed, →Guardian)、紫色表示
- **Growth Gate**: ATK+5 / SPD+10%、緑色表示、低リスク累積
- **Roulette Gate**: ATK +10 or -5 (50/50)、虹色表示

### Stage 6-10 概要 (RN版 stages/)
| Stage | Duration | Theme | 新要素 |
|-------|----------|-------|--------|
| 6 | 100s | Scrap Yard | Swarm 大群 |
| 7 | 110s | Fortress Gate | Phalanx 壁 |
| 8 | 120s | War Front | Juggernaut + Sentinel |
| 9 | 130s | Final Approach | 全敵種 + Carrier |
| 10 | 180s | Omega Core | Boss 2 (t=65s) |

# Design Notes

### 難易度スケーリング
- `DifficultyParams` クラスを新設し、stageId から各倍率を算出
- Enemy コンストラクタで `hpMultiplier`/`atkMultiplier` を受け取るか、
  `GRunnerGame` のスポーン時に適用するか → スポーン時に適用 (Enemy 側は変更最小限)
- `currentScrollSpeed` に scrollSpeedMultiplier を反映

### Boss バリアント
- `Boss` コンストラクタに `bossIndex` (default 1) を追加
- HP = `bossHp * (1 + (bossIndex - 1) * 0.5)`
- ドローン数 = `3 + (bossIndex - 1)`
- Phase 2+ のフェーズ閾値を bossIndex で変動

### Scatter 5方向発射
- Player の `_fireAutoShot()` でフォームが Scatter の場合、5方向弾を生成
- 角度: -20°, -10°, 0°, +10°, +20° の扇状
- 各弾の ATK は通常と同じ (0.6x で相殺)

### Sniper シールド貫通
- `BulletType.shieldPierce` を追加
- `Enemy.takeDamage()` で shieldPierce フラグが立っている場合、
  Phalanx / Sentinel のシールド軽減を無視

### フォームアンロック
- `GameProgress` に `unlockedForms: Set<FormType>` を追加
- Standard は常にアンロック、Heavy/HighSpeed は現状では初期アンロック扱い
  (RN版では Stage 3/5 クリア + 500Cr だが、Flutter版では Phase 6 で既に使用可能にしている)
- Sniper/Scatter/Guardian を新たにロック対象として追加
- `FormSelectScreen` にロック表示 + 購入ボタン

### Refit Gate
- `GateEffectType.refit` を追加、`value` にフォーム種別を格納 (enum index)
- Gate 通過時に `player.currentForm` を強制変更
- 紫色の Gate ビジュアル
