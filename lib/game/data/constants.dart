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

// I-frame
const double iframeDuration = 1.2; // seconds
const double iframeBlinkInterval = 0.1; // seconds

// Scoring
const int enemyKillScore = 100;
const int gatePassScore = 150;

// Gate
const double gateWidth = 140;
const double gateHeight = 30;
