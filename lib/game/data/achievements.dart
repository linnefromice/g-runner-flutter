// Achievement definitions and condition checking

import '../../data/game_progress.dart';
import 'constants.dart';

enum AchievementId {
  firstClear,
  bossSlayer,
  allForms,
  allStages,
  noDamageClear,
  comboMaster,
  creditHoarder,
  speedDemon,
  guardianAngel,
  endlessSurvivor,
}

class AchievementDefinition {
  final AchievementId id;
  final String name;
  final String description;
  final int reward;

  const AchievementDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.reward,
  });
}

const List<AchievementDefinition> allAchievements = [
  AchievementDefinition(
    id: AchievementId.firstClear,
    name: 'First Clear',
    description: 'Clear any stage',
    reward: 100,
  ),
  AchievementDefinition(
    id: AchievementId.bossSlayer,
    name: 'Boss Slayer',
    description: 'Defeat a boss',
    reward: 300,
  ),
  AchievementDefinition(
    id: AchievementId.allForms,
    name: 'Full Arsenal',
    description: 'Unlock all forms',
    reward: 500,
  ),
  AchievementDefinition(
    id: AchievementId.allStages,
    name: 'Conqueror',
    description: 'Clear all 15 stages',
    reward: 1000,
  ),
  AchievementDefinition(
    id: AchievementId.noDamageClear,
    name: 'Untouchable',
    description: 'Clear a stage without taking damage',
    reward: 500,
  ),
  AchievementDefinition(
    id: AchievementId.comboMaster,
    name: 'Combo Master',
    description: 'Activate awakening',
    reward: 200,
  ),
  AchievementDefinition(
    id: AchievementId.creditHoarder,
    name: 'Credit Hoarder',
    description: 'Accumulate 10000 credits',
    reward: 300,
  ),
  AchievementDefinition(
    id: AchievementId.speedDemon,
    name: 'Speed Demon',
    description: 'Clear a stage with High Speed form',
    reward: 200,
  ),
  AchievementDefinition(
    id: AchievementId.guardianAngel,
    name: 'Guardian Angel',
    description: 'Clear a stage at full HP',
    reward: 200,
  ),
  AchievementDefinition(
    id: AchievementId.endlessSurvivor,
    name: 'Endless Survivor',
    description: 'Survive 5 minutes in Endless mode',
    reward: 500,
  ),
];

class AchievementCheckResult {
  final AchievementId id;
  final bool newlyUnlocked;
  final int reward;

  const AchievementCheckResult({
    required this.id,
    required this.newlyUnlocked,
    required this.reward,
  });
}

class AchievementCheckInput {
  final bool stageClear;
  final bool bossDefeated;
  final int damageTaken;
  final int awakenedCount;
  final FormType activeForm;
  final int playerHp;
  final int playerMaxHp;
  final bool isEndless;
  final double endlessSurvivalTime;

  const AchievementCheckInput({
    this.stageClear = false,
    this.bossDefeated = false,
    this.damageTaken = 0,
    this.awakenedCount = 0,
    this.activeForm = FormType.standard,
    this.playerHp = 0,
    this.playerMaxHp = 100,
    this.isEndless = false,
    this.endlessSurvivalTime = 0,
  });
}

List<AchievementCheckResult> checkAchievements(
  AchievementCheckInput input,
  GameProgress progress,
) {
  final results = <AchievementCheckResult>[];
  final unlocked = progress.unlockedAchievements;

  void check(AchievementId id, bool condition) {
    if (condition && !unlocked.contains(id.name)) {
      final def = allAchievements.firstWhere((a) => a.id == id);
      results.add(AchievementCheckResult(
        id: id,
        newlyUnlocked: true,
        reward: def.reward,
      ));
    }
  }

  // first_clear: any stage clear
  check(AchievementId.firstClear, input.stageClear);

  // boss_slayer: defeat a boss
  check(AchievementId.bossSlayer, input.bossDefeated);

  // all_forms: all 6 forms unlocked
  check(AchievementId.allForms, progress.unlockedForms.length >= 6);

  // all_stages: all 15 stages cleared
  check(AchievementId.allStages, progress.unlockedStages.length >= 15);

  // no_damage_clear: clear with 0 damage taken
  check(AchievementId.noDamageClear,
      input.stageClear && input.damageTaken == 0);

  // combo_master: activated awakening
  check(AchievementId.comboMaster, input.awakenedCount > 0);

  // credit_hoarder: total credits >= 10000
  check(AchievementId.creditHoarder, progress.totalCreditsEarned >= 10000);

  // speed_demon: clear stage with High Speed
  check(AchievementId.speedDemon,
      input.stageClear && input.activeForm == FormType.highSpeed);

  // guardian_angel: clear stage at full HP
  check(AchievementId.guardianAngel,
      input.stageClear && input.playerHp >= input.playerMaxHp);

  // endless_survivor: survive 5 min in endless
  check(AchievementId.endlessSurvivor,
      input.isEndless && input.endlessSurvivalTime >= endlessSurvivorTime);

  return results;
}
