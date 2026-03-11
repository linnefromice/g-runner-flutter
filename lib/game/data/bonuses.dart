// Stage clear bonus calculation system

class BonusResult {
  final String key;
  final String label;
  final int points;
  final double creditMultiplier;

  const BonusResult({
    required this.key,
    required this.label,
    required this.points,
    required this.creditMultiplier,
  });
}

class BonusInput {
  final int damageTaken;
  final int awakenedCount;
  final int enemiesSpawned;
  final int enemiesKilled;
  final bool isBossStage;
  final double remainingTime;

  const BonusInput({
    required this.damageTaken,
    required this.awakenedCount,
    required this.enemiesSpawned,
    required this.enemiesKilled,
    required this.isBossStage,
    required this.remainingTime,
  });
}

List<BonusResult> calculateBonuses(BonusInput input) {
  final bonuses = <BonusResult>[];

  if (input.damageTaken == 0) {
    bonuses.add(const BonusResult(
      key: 'noDamage',
      label: 'NO DAMAGE',
      points: 0,
      creditMultiplier: 2.0,
    ));
  }

  if (input.awakenedCount > 0) {
    bonuses.add(BonusResult(
      key: 'combo',
      label: 'COMBO x${input.awakenedCount}',
      points: input.awakenedCount * 500,
      creditMultiplier: 1.0,
    ));
  }

  if (input.enemiesSpawned > 0 && input.enemiesKilled >= input.enemiesSpawned) {
    bonuses.add(const BonusResult(
      key: 'fullClear',
      label: 'FULL CLEAR',
      points: 1000,
      creditMultiplier: 1.0,
    ));
  }

  if (!input.isBossStage && input.remainingTime > 0) {
    bonuses.add(BonusResult(
      key: 'speedClear',
      label: 'SPEED CLEAR',
      points: input.remainingTime.floor() * 10,
      creditMultiplier: 1.0,
    ));
  }

  return bonuses;
}

int applyScoreBonus(int baseScore, List<BonusResult> bonuses) {
  var total = baseScore;
  for (final b in bonuses) {
    total += b.points;
  }
  if (bonuses.any((b) => b.key == 'noDamage')) {
    total = (total * 1.5).floor();
  }
  return total;
}

int applyCreditBonus(int baseCredits, List<BonusResult> bonuses) {
  var multiplier = 1.0;
  for (final b in bonuses) {
    if (b.creditMultiplier > multiplier) {
      multiplier = b.creditMultiplier;
    }
  }
  return (baseCredits * multiplier).floor();
}
