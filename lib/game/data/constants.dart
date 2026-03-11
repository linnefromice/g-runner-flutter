import 'dart:ui';

// Game balance constants — mirrors RN version's balance.ts (simplified for MVP)

// Coordinate system
const double logicalWidth = 320;

// Player
const double playerWidth = 32;
const double playerHeight = 40;
const double playerHitboxSize = 16;
const double playerMoveSpeed = 200; // logical units/sec (tap-to-move)
const int playerInitialHp = 100;
const int playerInitialAtk = 10;

// Player bullets
const double playerBulletSpeed = 400; // logical units/sec
const double playerBulletWidth = 4;
const double playerBulletHeight = 12;
const double playerFireInterval = 0.2; // seconds

// Enemy bullets
const double enemyBulletSpeed = 180;
const double enemyBulletWidth = 6;
const double enemyBulletHeight = 6;

// Enemies
const double baseScrollSpeed = 80; // logical units/sec

// Enemy stats: {hp, atk, shootInterval (seconds), moveSpeed}
class EnemyStats {
  final int hp;
  final int atk;
  final double shootInterval;
  final double moveSpeed;

  const EnemyStats({
    required this.hp,
    required this.atk,
    required this.shootInterval,
    required this.moveSpeed,
  });
}

const stationaryStats = EnemyStats(hp: 20, atk: 10, shootInterval: 2.0, moveSpeed: 0);
const patrolStats = EnemyStats(hp: 40, atk: 10, shootInterval: 2.5, moveSpeed: 60);
const rushStats = EnemyStats(hp: 15, atk: 15, shootInterval: 0, moveSpeed: 200);
const swarmStats = EnemyStats(hp: 1, atk: 5, shootInterval: 0, moveSpeed: 0);
const phalanxStats = EnemyStats(hp: 60, atk: 15, shootInterval: 2.0, moveSpeed: 40);
const juggernautStats = EnemyStats(hp: 120, atk: 25, shootInterval: 1.5, moveSpeed: 0);
const dodgerStats = EnemyStats(hp: 35, atk: 12, shootInterval: 1.8, moveSpeed: 120);
const splitterStats = EnemyStats(hp: 50, atk: 8, shootInterval: 2.0, moveSpeed: 0);
const summonerStats = EnemyStats(hp: 80, atk: 0, shootInterval: 0, moveSpeed: 0);
const sentinelStats = EnemyStats(hp: 120, atk: 15, shootInterval: 2.0, moveSpeed: 0);
const carrierStats = EnemyStats(hp: 100, atk: 0, shootInterval: 0, moveSpeed: 36);

// Swarm sine wave parameters
const double swarmSineAmplitude = 40; // horizontal wobble amplitude
const double swarmSineFrequency = 3.0; // wobble frequency

// Phalanx shield damage reduction
const double phalanxShieldDamageMultiplier = 0.5;

// Juggernaut
const double juggernautScrollFactor = 0.3;
const double juggernautSineAmplitude = 20;

// Dodger
const double dodgerDetectRadius = 60;
const double dodgerDetectRange = 120;
const double dodgerCooldown = 0.8;

// Splitter — spawns 3 swarms on death
const List<double> splitterSpawnOffsets = [-20, 0, 20];

// Summoner
const double summonerSpawnInterval = 3.0;
const int summonerMaxSpawns = 6;

// Sentinel
const double sentinelShieldReduction = 0.5;

// Carrier
const double carrierScrollFactor = 0.5;
const double carrierPatrolSpeedFactor = 0.6;
const double carrierSpawnInterval = 5.0;

// Scoring per enemy type
const int rushKillScore = 100;
const int swarmKillScore = 30;
const int phalanxKillScore = 300;
const int juggernautKillScore = 500;
const int dodgerKillScore = 250;
const int splitterKillScore = 200;
const int summonerKillScore = 400;
const int sentinelKillScore = 600;
const int carrierKillScore = 500;

// I-frame
const double iframeDuration = 1.2; // seconds
const double iframeBlinkInterval = 0.1; // seconds

// Scoring
const int enemyKillScore = 100;
const int gatePassScore = 150;

// Gate
const double gateWidth = 140;
const double gateHeight = 30;

// Combo & Awakening
const int comboThreshold = 3;
const double awakenedDuration = 10.0; // seconds
const double awakenedAtkMultiplier = 2.0;
const double awakenedSpeedMultiplier = 1.2;
const double awakenedFireRateMultiplier = 1.3;
const double awakenedWarningTime = 3.0; // seconds before expiry
const double awakenedSlowMotionFactor = 0.3;
const double awakenedSlowMotionDuration = 0.3; // seconds

// EX Burst
const double exGaugeMax = 100;
const double exGainOnEnemyKill = 5;
const double exGainOnGatePass = 10;
const double exGainOnBossHit = 2;
const double exBurstDuration = 2.0; // seconds
const double exBurstDamage = 50; // per tick
const double exBurstTickInterval = 0.1; // seconds
const double exBurstWidth = 80; // logical units

// Form definitions
enum FormType { standard, heavyArtillery, highSpeed, sniper, scatter, guardian }

class FormDefinition {
  final FormType type;
  final String name;
  final double speedMultiplier;
  final double atkMultiplier;
  final double fireRateMultiplier;
  final BulletType bulletType;
  final Color bulletColor;

  const FormDefinition({
    required this.type,
    required this.name,
    required this.speedMultiplier,
    required this.atkMultiplier,
    required this.fireRateMultiplier,
    required this.bulletType,
    required this.bulletColor,
  });
}

enum BulletType { normal, explosion, pierce, shieldPierce, scatter, homing }

const formStandard = FormDefinition(
  type: FormType.standard,
  name: 'Standard',
  speedMultiplier: 1.0,
  atkMultiplier: 1.0,
  fireRateMultiplier: 1.0,
  bulletType: BulletType.normal,
  bulletColor: Color(0xFF00D4FF),
);

const formHeavyArtillery = FormDefinition(
  type: FormType.heavyArtillery,
  name: 'Heavy Artillery',
  speedMultiplier: 0.8,
  atkMultiplier: 1.8,
  fireRateMultiplier: 0.6,
  bulletType: BulletType.explosion,
  bulletColor: Color(0xFFFF6600),
);

const formHighSpeed = FormDefinition(
  type: FormType.highSpeed,
  name: 'High Speed',
  speedMultiplier: 1.4,
  atkMultiplier: 0.7,
  fireRateMultiplier: 1.5,
  bulletType: BulletType.pierce,
  bulletColor: Color(0xFF00FF88),
);

const formSniper = FormDefinition(
  type: FormType.sniper,
  name: 'Sniper',
  speedMultiplier: 0.6,
  atkMultiplier: 2.5,
  fireRateMultiplier: 0.3,
  bulletType: BulletType.shieldPierce,
  bulletColor: Color(0xFFAA66FF),
);

const formScatter = FormDefinition(
  type: FormType.scatter,
  name: 'Scatter',
  speedMultiplier: 1.0,
  atkMultiplier: 0.6,
  fireRateMultiplier: 1.0,
  bulletType: BulletType.scatter,
  bulletColor: Color(0xFFFFAA44),
);

const formGuardian = FormDefinition(
  type: FormType.guardian,
  name: 'Guardian',
  speedMultiplier: 0.7,
  atkMultiplier: 0.8,
  fireRateMultiplier: 0.8,
  bulletType: BulletType.normal,
  bulletColor: Color(0xFF44AAFF),
);

// Scatter bullet
const int scatterBulletCount = 5;
const double scatterSpreadAngle = 10.0; // degrees between bullets

// Guardian damage reduction
const double guardianDamageReduction = 0.8; // 20% less damage

// Sniper bullet
const double sniperBulletSpeed = 600;

// Form unlock conditions
class FormUnlockCondition {
  final int requiredStage;
  final int cost;
  const FormUnlockCondition({required this.requiredStage, required this.cost});
}

const Map<FormType, FormUnlockCondition> formUnlockConditions = {
  FormType.sniper: FormUnlockCondition(requiredStage: 7, cost: 800),
  FormType.scatter: FormUnlockCondition(requiredStage: 8, cost: 800),
  FormType.guardian: FormUnlockCondition(requiredStage: 10, cost: 1000),
};

// Difficulty scaling
const double difficultyScrollSpeedPerStage = 0.06;
const double difficultyEnemyHpPerStage = 0.12;
const double difficultyEnemyAtkPerStage = 0.08;
const double difficultyBulletSpeedPerStage = 0.05;
const double difficultyAttackIntervalPerStage = 0.04;
const double difficultyAttackIntervalMin = 0.6;
const int difficultyMaxConcurrentBase = 2;
const int difficultyMaxConcurrentLimit = 7;

// Transform gauge
const double transformGaugeMax = 100;
const double transformGainOnEnemyKill = 8;
const double transformGainOnGatePass = 12;
const double transformGainPerSecond = 2;

// Transform bonus (after switching forms)
const double transformBonusDuration = 5.0; // seconds
const double transformBonusAtkMultiplier = 1.25;
const double transformBonusSpeedMultiplier = 1.15;
const double transformBonusFireRateMultiplier = 1.2;
const int transformBonusHpHeal = 5;

// Explosion bullet
const double explosionRadius = 40; // logical units

// Boss
const int bossHp = 500;
const int bossAtk = 15;
const double bossWidth = 200;
const double bossHeight = 120;
const double bossHoverY = 40; // target Y position
const double bossSlideSpeed = 30; // units/sec during entrance
const double bossHoverAmplitude = 30;
const double bossHoverPeriod = 3.0; // seconds
const double bossShootInterval1 = 2.0; // Phase 1
const double bossShootInterval2 = 1.2; // Phase 2
const double bossShootInterval3 = 1.0; // Phase 3
const int bossSpreadCount = 5;
const double bossSpreadAngle = 15.0; // degrees between bullets
const double bossBulletSpeed = 200;
const double bossPhase2Threshold = 0.66;
const double bossPhase3Threshold = 0.33;
const int bossDroneCount = 3;
const int bossDroneHp = 25;
const double bossScrollSpeedMultiplier = 0.5;
const int bossKillScore = 5000;
const double bossDeathShakeIntensity = 8.0;
const double bossDeathShakeDuration = 0.3;

// Boss laser
const double bossLaserWarningDuration = 1.0; // seconds
const double bossLaserFireDuration = 1.5; // seconds
const double bossLaserWidth = 30; // logical units (Boss 1/2)
const double bossLaserWidthBoss3 = 40; // logical units (Boss 3+)
const int bossLaserDamage = 20; // per tick
const double bossLaserTickInterval = 0.3; // seconds
const double bossLaserCooldown = 4.0; // seconds
const double bossLaserPulseSpeed = 8.0; // rad/s for warning animation

// Credits (currency)
const int creditPerStationary = 1;
const int creditPerPatrol = 2;
const int creditPerRush = 1;
const int creditPerSwarm = 0;
const int creditPerPhalanx = 4;
const int creditPerJuggernaut = 7;
const int creditPerDodger = 3;
const int creditPerSplitter = 3;
const int creditPerSummoner = 5;
const int creditPerSentinel = 7;
const int creditPerCarrier = 6;
const int creditPerStageClear = 50;
const int creditPerBossDefeat = 150;

// Upgrades
const int maxAtkLevel = 10;
const int maxHpLevel = 10;
const int maxSpeedLevel = 5;
const int maxDefLevel = 5;
const int atkUpgradePerLevel = 2;
const int hpUpgradePerLevel = 10;
const double speedUpgradePerLevel = 0.05;
const double defUpgradePerLevel = 0.03;
const int atkUpgradeCostBase = 100;
const int hpUpgradeCostBase = 100;
const int speedUpgradeCostBase = 100;
const int defUpgradeCostBase = 150;

// Graze (near-miss detection)
const double grazeExtremeExpand = 1; // pixels beyond actual hitbox
const double grazeCloseExpand = 4; // pixels beyond actual hitbox
const double grazeExpandPassiveBonus = 4; // extra pixels from graze_expand passive

// Graze rewards
const int grazeNormalScore = 20;
const double grazeNormalExGain = 3;
const double grazeNormalTfGain = 2;
const int grazeCloseScore = 50;
const double grazeCloseExGain = 6;
const double grazeCloseTfGain = 4;
const int grazeExtremeScore = 150;
const double grazeExtremeExGain = 12;
const double grazeExtremeTfGain = 8;

// Parry / Just Transform
const double parryWindow = 0.2; // 200ms window after transform
const double parryShockwaveRadius = 60;
const int parryShockwaveDamage = 30;
const int parryScore = 300;
const double parryExGain = 15;
const double parryShockwaveDuration = 0.2; // visual effect duration

// Passive skill constants
const double armorDamageReduction = 0.8; // 20% less damage
const double hpRegenPerSecond = 1.0; // HP per second
const double criticalChancePercent = 0.15; // 15%
const double criticalDamageMultiplier = 2.0;
const double shieldRegenCooldown = 15.0; // seconds
const int counterShotBulletCount = 8; // bullets in all directions
const double slowOnHitDuration = 2.0; // seconds
const double slowOnHitFactor = 0.5; // 50% speed

// Boss 3 homing
const int bossHomingCount = 2; // outer bullets of spread become homing
const double bossHomingTurnSpeed = 2.0; // radians/sec
const double bossHomingBulletSpeed = 150; // slower than normal spread

// Debris
const int debrisHp = 50;
const double debrisWidth = 40;
const double debrisHeight = 40;
const int debrisContactDamage = 20;
const int debrisDestroyScore = 50;
const int debrisDestroyCredit = 1;

// Boost Lane
const double boostLaneScoreMultiplier = 1.5;
const double boostLaneScrollMultiplier = 1.3;

// Credit Boost upgrade
const int maxCreditBoostLevel = 5;
const double creditBoostPerLevel = 0.1; // +10% per level
const int creditBoostCostBase = 200;

// Endless mode
const double endlessWaveDuration = 30.0; // seconds per wave
const int endlessBaseEnemyCount = 3;
const int endlessMaxEnemyTypes = 11;
const double endlessScrollSpeedPerMinute = 0.1;
const double endlessHpPerMinute = 0.3;
const double endlessAtkPerMinute = 0.15;
const int endlessBaseMaxConcurrent = 6;
const double endlessMaxConcurrentPerMinute = 2.0;
const double endlessSurvivorTime = 300.0; // 5 minutes for achievement

// Screen shake
const double shakePlayerHitIntensity = 1.5;
const double shakePlayerHitDuration = 0.15;
const double shakeEnemyKillIntensity = 2.0;
const double shakeEnemyKillDuration = 0.1;
