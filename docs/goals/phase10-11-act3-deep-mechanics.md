# Goal
Act 3 の全ステージ (Stage 11-15 + Boss 3) とステージクリアボーナスを実装し、
フォーム XP / スキルツリー / Graze / Parry の上級メカニクスでゲームの深みを完成させる。

# Context
- Phase 0-9 完了: 11敵種、6フォーム、Boss 1-2、Stage 1-10、全Gate種、難易度スケーリング実装済み
- IMPLEMENTATION_PLAN.md の Phase 10 + Phase 11 に該当
- マイルストーン: 「Act 3 Complete」+「Deep Mechanics」を同時達成
- RN版では Stage 11-15 が Act 3、スキルツリーは全フォーム共通の3レベル制

# Scope
## In Scope
### Phase 10: Act 3
- Stage 11-14 タイムライン (各110-130秒)
- Stage 15 タイムライン (180秒, Boss 3)
- Boss 3 バリアント (HP 1000, ドローン5体, レーザー幅40px, ホーミング弾2発)
- ステージクリアボーナス (ノーダメ/コンボ/フルクリア/スピード)
- GameProgress.unlockNextStage を Stage 15 まで拡張

### Phase 11: 上級メカニクス
- フォーム XP システム (敵撃破+5, 強敵+10, Gate通過+8, Graze+3/6/15)
- スキルツリー (6フォーム × 3レベル × A/B 二択 = 36スキル枠)
- パッシブスキル実装 (優先度の高い8種: pierce, double_shot, armor, hp_regen, heal_on_hit, critical_chance, shield, counter_shot)
- Graze メカニクス (3段階: normal/close/extreme)
- Parry / Just Transform (変身直後200msの無敵+衝撃波)
- HUD に Form XP バー、Graze カウンター表示
- Result 画面にボーナス内訳表示

## Out of Scope
- パッシブスキル全19種の完全実装 (残り11種は後続イテレーションで追加可)
- Endless モード (Phase 12)
- 実績システム (Phase 12)
- Debris / Boost Lane (Phase 13)
- 設定 / i18n (Phase 13)

# Expected Output
### 新規ファイル
- `lib/game/data/stage11_data.dart` 〜 `stage15_data.dart`
- `lib/game/data/form_skills.dart` — スキルツリー定義 + パッシブスキル enum
- `lib/game/data/bonuses.dart` — クリアボーナス計算ロジック
- `lib/game/systems/graze_system.dart` — Graze 判定 (もしくは GRunnerGame 内に統合)

### 変更ファイル
- `lib/game/data/constants.dart` — ボーナス定数, XP閾値, Graze距離, Parry窓
- `lib/game/data/stages.dart` — Stage 11-15 登録
- `lib/game/components/boss.dart` — Boss 3: ホーミング弾, レーザー幅拡大
- `lib/game/components/player.dart` — formXp 追跡, パッシブスキル適用, Parry状態
- `lib/game/components/bullet.dart` — ホーミング弾タイプ追加
- `lib/game/g_runner_game.dart` — Graze判定, ボーナス計算, XP付与, Parry処理
- `lib/game/ui/hud.dart` — XPバー, Grazeカウンター, アクティブスキル表示
- `lib/screens/result_screen.dart` — ボーナス内訳セクション
- `lib/data/game_progress.dart` — formXp/formSkills永続化, unlockNextStage上限→15

# References
## RN版の関連ファイル
- `src/game/stages/stage11.ts` 〜 `stage15.ts` — Act 3 タイムライン
- `src/game/bonuses.ts` — ボーナス計算 (noDamage ×1.5 score / ×2.0 credit, combo ×500pt, fullClear +1000pt, speed ×10pt/s)
- `src/game/formSkills.ts` — スキルツリー定義 (6フォーム × 3Lv × A/B)
- `src/types/formSkills.ts` — パッシブスキル型定義
- `src/engine/formSkillResolver.ts` — パッシブスキル効果適用
- `src/engine/systems/CollisionSystem.ts` — Graze判定 + Parry処理
- `src/constants/balance.ts` — 全バランス値

## 実装ノート
### Boss 3 (RN版)
- HP: 1000 (= 500 × 2.0)、ドローン 5体
- レーザー幅: 40px (Boss 1-2 は 30px)
- ホーミング弾: スプレッド5発のうち外側2発が追尾
- phase2: 75%, phase3: 50% (Boss 2 と同じ閾値)

### ステージクリアボーナス (RN版)
| ボーナス | 条件 | 効果 |
|---------|------|------|
| No Damage | damageTaken == 0 | Score ×1.5, Credit ×2.0 |
| Combo | awakenedCount > 0 | +awakenedCount × 500 pts |
| Full Clear | kills >= spawned | +1000 pts |
| Speed Clear | remainingTime > 0 (非ボス) | +remainingTime × 10 pts |

### Form XP (RN版)
- Lv1: 50 XP, Lv2: 200 XP (累計), Lv3: 500 XP (累計)
- 獲得源: 敵撃破+5, 強敵+10, Gate+8, Graze(normal+3/close+6/extreme+15)

### Graze (RN版)
- 判定: 敵弾がプレイヤーの視覚hitbox (32×40) 内だが実hitbox (16×16) 外
- 3段階: normal (+20pt/+3EX), close (+50pt/+6EX), extreme (+150pt/+12EX)

### Parry / Just Transform (RN版)
- 窓: Transform発動後 200ms
- 効果: ダメージ無効 + 半径60の衝撃波 (30ダメージ) + 範囲内弾消し
- 報酬: +300pt, +15EX, ヒットストップ50ms, 画面シェイク

### スキルツリー (RN版 — 6フォーム)
| Form | Lv1 A/B | Lv2 A/B | Lv3 A/B |
|------|---------|---------|---------|
| Standard | BulletSpd+20% / BulletSize+30% | FR+15% / DMG+20% | double_shot / pierce |
| Heavy | AoE+40% / ExpDMG+30% | armor / BulletSpd+25% | slow_on_hit / double_explosion |
| HighSpeed | MoveSpd+20% / GrazeRange+ | pierce+1 / FR+20% | afterimage / speed_atk_bonus |
| Sniper | BulletSpd+30% / critical_15% | double_shot / pierce+shield | auto_charge / xp_on_crit |
| Scatter | BulletCount+2 / TighterSpread | CloseRange+40% / weak_homing | omnidirectional / heal_on_hit |
| Guardian | hp_regen / DMGReduce+10% | counter_shot / shield | AllyBulletSpd+20% / ex_on_hit |

# Design Notes
- Phase 10 と 11 はスコープが大きいため、dev-loop 内で複数イテレーションに分割する
  - Iteration 1: Stage 11-15 + Boss 3 基本
  - Iteration 2: クリアボーナス + Result画面
  - Iteration 3: Form XP + スキルツリーデータ
  - Iteration 4: パッシブスキル実装 (優先8種)
  - Iteration 5: Graze + Parry + HUD
- パッシブスキルは全19種のうち、まず8種 (pierce, double_shot, armor, hp_regen, heal_on_hit, critical_chance, shield, counter_shot) を実装。残りは後続で追加
- Boss 3 のホーミング弾は新しい BulletType.homing を追加し、update() で Player 方向にゆるく追尾
- Graze 判定は _checkCollisions() 内で EnemyBullet とプレイヤーの距離を計算
- formXp / formSkills は GameProgress に永続化し、セッション間で保持
