import 'constants.dart';

// Form XP level thresholds (cumulative)
const int formXpLv1 = 50;
const int formXpLv2 = 200; // cumulative
const int formXpLv3 = 500; // cumulative

// XP gain sources
const int xpPerEnemyKill = 5;
const int xpPerStrongEnemyKill = 10; // Phalanx, Juggernaut, Sentinel, Carrier
const int xpPerGatePass = 8;
const int xpPerGrazeNormal = 3;
const int xpPerGrazeClose = 6;
const int xpPerGrazeExtreme = 15;

int formLevelFromXp(int xp) {
  if (xp >= formXpLv3) return 3;
  if (xp >= formXpLv2) return 2;
  if (xp >= formXpLv1) return 1;
  return 0;
}

int xpForNextLevel(int level) {
  switch (level) {
    case 0:
      return formXpLv1;
    case 1:
      return formXpLv2;
    case 2:
      return formXpLv3;
    default:
      return formXpLv3; // max level
  }
}

// Passive skill IDs
enum PassiveSkillId {
  pierce,
  doubleShot,
  armor,
  hpRegen,
  healOnHit,
  criticalChance,
  shield,
  counterShot,
  slowOnHit,
  doubleExplosion,
  afterimage,
  speedAtkBonus,
  weakHoming,
  exOnHit,
  omnidirectional,
  grazeExpand,
  xpOnCrit,
  autoCharge,
}

// Skill effect types
enum SkillEffectType { statMultiply, statAdd, passive }
enum SkillStatType { bulletSpeed, bulletSize, fireRate, damage, moveSpeed, aoeRadius, damageReduce }

class SkillEffect {
  final SkillEffectType type;
  final SkillStatType? stat;
  final double? value;
  final PassiveSkillId? passiveId;

  const SkillEffect.multiply({required SkillStatType this.stat, required double this.value})
      : type = SkillEffectType.statMultiply,
        passiveId = null;

  const SkillEffect.add({required SkillStatType this.stat, required double this.value})
      : type = SkillEffectType.statAdd,
        passiveId = null;

  const SkillEffect.passive(PassiveSkillId this.passiveId)
      : type = SkillEffectType.passive,
        stat = null,
        value = null;
}

class SkillChoice {
  final String id;
  final String name;
  final SkillEffect effect;

  const SkillChoice({required this.id, required this.name, required this.effect});
}

class SkillLevel {
  final SkillChoice choiceA;
  final SkillChoice choiceB;

  const SkillLevel({required this.choiceA, required this.choiceB});
}

class FormSkillTree {
  final FormType formType;
  final SkillLevel level1;
  final SkillLevel level2;
  final SkillLevel level3;

  const FormSkillTree({
    required this.formType,
    required this.level1,
    required this.level2,
    required this.level3,
  });

  SkillLevel levelAt(int level) {
    switch (level) {
      case 1:
        return level1;
      case 2:
        return level2;
      case 3:
        return level3;
      default:
        return level1;
    }
  }
}

// Skill tree definitions for all 6 forms
const skillTreeStandard = FormSkillTree(
  formType: FormType.standard,
  level1: SkillLevel(
    choiceA: SkillChoice(id: 'std_1a', name: 'Bullet Spd +20%',
        effect: SkillEffect.multiply(stat: SkillStatType.bulletSpeed, value: 1.2)),
    choiceB: SkillChoice(id: 'std_1b', name: 'Bullet Size +30%',
        effect: SkillEffect.multiply(stat: SkillStatType.bulletSize, value: 1.3)),
  ),
  level2: SkillLevel(
    choiceA: SkillChoice(id: 'std_2a', name: 'Fire Rate +15%',
        effect: SkillEffect.multiply(stat: SkillStatType.fireRate, value: 1.15)),
    choiceB: SkillChoice(id: 'std_2b', name: 'Damage +20%',
        effect: SkillEffect.multiply(stat: SkillStatType.damage, value: 1.2)),
  ),
  level3: SkillLevel(
    choiceA: SkillChoice(id: 'std_3a', name: 'Double Shot',
        effect: SkillEffect.passive(PassiveSkillId.doubleShot)),
    choiceB: SkillChoice(id: 'std_3b', name: 'Pierce',
        effect: SkillEffect.passive(PassiveSkillId.pierce)),
  ),
);

const skillTreeHeavy = FormSkillTree(
  formType: FormType.heavyArtillery,
  level1: SkillLevel(
    choiceA: SkillChoice(id: 'hvy_1a', name: 'AoE +40%',
        effect: SkillEffect.multiply(stat: SkillStatType.aoeRadius, value: 1.4)),
    choiceB: SkillChoice(id: 'hvy_1b', name: 'Exp DMG +30%',
        effect: SkillEffect.multiply(stat: SkillStatType.damage, value: 1.3)),
  ),
  level2: SkillLevel(
    choiceA: SkillChoice(id: 'hvy_2a', name: 'Armor',
        effect: SkillEffect.passive(PassiveSkillId.armor)),
    choiceB: SkillChoice(id: 'hvy_2b', name: 'Bullet Spd +25%',
        effect: SkillEffect.multiply(stat: SkillStatType.bulletSpeed, value: 1.25)),
  ),
  level3: SkillLevel(
    choiceA: SkillChoice(id: 'hvy_3a', name: 'Slow on Hit',
        effect: SkillEffect.passive(PassiveSkillId.slowOnHit)),
    choiceB: SkillChoice(id: 'hvy_3b', name: 'Double Explosion',
        effect: SkillEffect.passive(PassiveSkillId.doubleExplosion)),
  ),
);

const skillTreeHighSpeed = FormSkillTree(
  formType: FormType.highSpeed,
  level1: SkillLevel(
    choiceA: SkillChoice(id: 'spd_1a', name: 'Move Spd +20%',
        effect: SkillEffect.multiply(stat: SkillStatType.moveSpeed, value: 1.2)),
    choiceB: SkillChoice(id: 'spd_1b', name: 'Graze Expand',
        effect: SkillEffect.passive(PassiveSkillId.grazeExpand)),
  ),
  level2: SkillLevel(
    choiceA: SkillChoice(id: 'spd_2a', name: 'Pierce +1',
        effect: SkillEffect.passive(PassiveSkillId.pierce)),
    choiceB: SkillChoice(id: 'spd_2b', name: 'Fire Rate +20%',
        effect: SkillEffect.multiply(stat: SkillStatType.fireRate, value: 1.2)),
  ),
  level3: SkillLevel(
    choiceA: SkillChoice(id: 'spd_3a', name: 'Afterimage',
        effect: SkillEffect.passive(PassiveSkillId.afterimage)),
    choiceB: SkillChoice(id: 'spd_3b', name: 'Speed ATK Bonus',
        effect: SkillEffect.passive(PassiveSkillId.speedAtkBonus)),
  ),
);

const skillTreeSniper = FormSkillTree(
  formType: FormType.sniper,
  level1: SkillLevel(
    choiceA: SkillChoice(id: 'snp_1a', name: 'Bullet Spd +30%',
        effect: SkillEffect.multiply(stat: SkillStatType.bulletSpeed, value: 1.3)),
    choiceB: SkillChoice(id: 'snp_1b', name: 'Critical 15%',
        effect: SkillEffect.passive(PassiveSkillId.criticalChance)),
  ),
  level2: SkillLevel(
    choiceA: SkillChoice(id: 'snp_2a', name: 'Double Shot',
        effect: SkillEffect.passive(PassiveSkillId.doubleShot)),
    choiceB: SkillChoice(id: 'snp_2b', name: 'Pierce+Shield',
        effect: SkillEffect.passive(PassiveSkillId.pierce)),
  ),
  level3: SkillLevel(
    choiceA: SkillChoice(id: 'snp_3a', name: 'Auto Charge',
        effect: SkillEffect.passive(PassiveSkillId.autoCharge)),
    choiceB: SkillChoice(id: 'snp_3b', name: 'XP on Crit',
        effect: SkillEffect.passive(PassiveSkillId.xpOnCrit)),
  ),
);

const skillTreeScatter = FormSkillTree(
  formType: FormType.scatter,
  level1: SkillLevel(
    choiceA: SkillChoice(id: 'sct_1a', name: 'Bullet Count +2',
        effect: SkillEffect.add(stat: SkillStatType.bulletSize, value: 2)),
    choiceB: SkillChoice(id: 'sct_1b', name: 'Tighter Spread',
        effect: SkillEffect.multiply(stat: SkillStatType.bulletSize, value: 1.3)),
  ),
  level2: SkillLevel(
    choiceA: SkillChoice(id: 'sct_2a', name: 'Close Range +40%',
        effect: SkillEffect.multiply(stat: SkillStatType.damage, value: 1.4)),
    choiceB: SkillChoice(id: 'sct_2b', name: 'Weak Homing',
        effect: SkillEffect.passive(PassiveSkillId.weakHoming)),
  ),
  level3: SkillLevel(
    choiceA: SkillChoice(id: 'sct_3a', name: 'Omnidirectional',
        effect: SkillEffect.passive(PassiveSkillId.omnidirectional)),
    choiceB: SkillChoice(id: 'sct_3b', name: 'Heal on Hit',
        effect: SkillEffect.passive(PassiveSkillId.healOnHit)),
  ),
);

const skillTreeGuardian = FormSkillTree(
  formType: FormType.guardian,
  level1: SkillLevel(
    choiceA: SkillChoice(id: 'grd_1a', name: 'HP Regen',
        effect: SkillEffect.passive(PassiveSkillId.hpRegen)),
    choiceB: SkillChoice(id: 'grd_1b', name: 'DMG Reduce +10%',
        effect: SkillEffect.multiply(stat: SkillStatType.damageReduce, value: 1.1)),
  ),
  level2: SkillLevel(
    choiceA: SkillChoice(id: 'grd_2a', name: 'Counter Shot',
        effect: SkillEffect.passive(PassiveSkillId.counterShot)),
    choiceB: SkillChoice(id: 'grd_2b', name: 'Shield',
        effect: SkillEffect.passive(PassiveSkillId.shield)),
  ),
  level3: SkillLevel(
    choiceA: SkillChoice(id: 'grd_3a', name: 'Ally Bullet Spd +20%',
        effect: SkillEffect.multiply(stat: SkillStatType.bulletSpeed, value: 1.2)),
    choiceB: SkillChoice(id: 'grd_3b', name: 'EX on Hit',
        effect: SkillEffect.passive(PassiveSkillId.exOnHit)),
  ),
);

const Map<FormType, FormSkillTree> allSkillTrees = {
  FormType.standard: skillTreeStandard,
  FormType.heavyArtillery: skillTreeHeavy,
  FormType.highSpeed: skillTreeHighSpeed,
  FormType.sniper: skillTreeSniper,
  FormType.scatter: skillTreeScatter,
  FormType.guardian: skillTreeGuardian,
};

// Resolved skill stats after applying all selected skills
class ResolvedFormSkills {
  double bulletSpeedMul;
  double bulletSizeMul;
  double fireRateMul;
  double damageMul;
  double moveSpeedMul;
  double aoeRadiusMul;
  double damageReduceMul;
  Set<PassiveSkillId> passives;

  ResolvedFormSkills()
      : bulletSpeedMul = 1.0,
        bulletSizeMul = 1.0,
        fireRateMul = 1.0,
        damageMul = 1.0,
        moveSpeedMul = 1.0,
        aoeRadiusMul = 1.0,
        damageReduceMul = 1.0,
        passives = {};
}

ResolvedFormSkills resolveFormSkills(List<String> selectedSkillIds) {
  final result = ResolvedFormSkills();

  // Collect all skill effects from all trees
  final allChoices = <String, SkillEffect>{};
  for (final tree in allSkillTrees.values) {
    for (final level in [tree.level1, tree.level2, tree.level3]) {
      allChoices[level.choiceA.id] = level.choiceA.effect;
      allChoices[level.choiceB.id] = level.choiceB.effect;
    }
  }

  for (final skillId in selectedSkillIds) {
    final effect = allChoices[skillId];
    if (effect == null) continue;

    switch (effect.type) {
      case SkillEffectType.statMultiply:
        switch (effect.stat!) {
          case SkillStatType.bulletSpeed:
            result.bulletSpeedMul *= effect.value!;
          case SkillStatType.bulletSize:
            result.bulletSizeMul *= effect.value!;
          case SkillStatType.fireRate:
            result.fireRateMul *= effect.value!;
          case SkillStatType.damage:
            result.damageMul *= effect.value!;
          case SkillStatType.moveSpeed:
            result.moveSpeedMul *= effect.value!;
          case SkillStatType.aoeRadius:
            result.aoeRadiusMul *= effect.value!;
          case SkillStatType.damageReduce:
            result.damageReduceMul *= effect.value!;
        }
      case SkillEffectType.statAdd:
        // Add stats are tracked as multipliers for simplicity
        break;
      case SkillEffectType.passive:
        result.passives.add(effect.passiveId!);
    }
  }

  return result;
}
