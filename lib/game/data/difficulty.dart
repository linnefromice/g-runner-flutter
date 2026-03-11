import 'dart:math' as math;

import 'constants.dart';

/// Difficulty parameters computed from stage ID
class DifficultyParams {
  final double scrollSpeedMultiplier;
  final double enemyHpMultiplier;
  final double enemyAtkMultiplier;
  final double bulletSpeedMultiplier;
  final double attackIntervalMultiplier;
  final int maxConcurrentEnemies;

  const DifficultyParams({
    required this.scrollSpeedMultiplier,
    required this.enemyHpMultiplier,
    required this.enemyAtkMultiplier,
    required this.bulletSpeedMultiplier,
    required this.attackIntervalMultiplier,
    required this.maxConcurrentEnemies,
  });
}

DifficultyParams getDifficultyForStage(int stageId) {
  return DifficultyParams(
    scrollSpeedMultiplier: 1.0 + (stageId - 1) * difficultyScrollSpeedPerStage,
    enemyHpMultiplier: 1.0 + (stageId - 1) * difficultyEnemyHpPerStage,
    enemyAtkMultiplier: 1.0 + (stageId - 1) * difficultyEnemyAtkPerStage,
    bulletSpeedMultiplier: 1.0 + (stageId - 1) * difficultyBulletSpeedPerStage,
    attackIntervalMultiplier: math.max(
      difficultyAttackIntervalMin,
      1.0 - (stageId - 1) * difficultyAttackIntervalPerStage,
    ),
    maxConcurrentEnemies: math.min(
      difficultyMaxConcurrentLimit,
      difficultyMaxConcurrentBase + stageId ~/ 2,
    ),
  );
}

int getBossHp(int bossIndex) {
  return (bossHp * (1 + (bossIndex - 1) * 0.5)).round();
}
