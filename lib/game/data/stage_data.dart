// Stage timeline definitions

enum SpawnEventType { enemy, gate }

enum EnemyType { stationary, patrol }

enum GateEffectType { atkAdd, speedMultiply }

class GateEffect {
  final GateEffectType type;
  final double value;

  const GateEffect({required this.type, required this.value});
}

class SpawnEvent {
  final double time; // seconds from stage start
  final SpawnEventType type;

  // Enemy spawn fields
  final EnemyType? enemyType;
  final double? x;

  // Gate spawn fields
  final GateEffect? leftEffect;
  final GateEffect? rightEffect;

  const SpawnEvent.enemy({
    required this.time,
    required EnemyType this.enemyType,
    required double this.x,
  })  : type = SpawnEventType.enemy,
        leftEffect = null,
        rightEffect = null;

  const SpawnEvent.gate({
    required this.time,
    required GateEffect this.leftEffect,
    required GateEffect this.rightEffect,
  })  : type = SpawnEventType.gate,
        enemyType = null,
        x = null;
}

class StageData {
  final int id;
  final String name;
  final double duration; // seconds
  final List<SpawnEvent> timeline;

  const StageData({
    required this.id,
    required this.name,
    required this.duration,
    required this.timeline,
  });
}

final stage1 = StageData(
  id: 1,
  name: 'Stage 1',
  duration: 60,
  timeline: [
    // Wave 1: single stationary enemies
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.stationary, x: 160),
    const SpawnEvent.enemy(time: 4, enemyType: EnemyType.stationary, x: 80),
    const SpawnEvent.enemy(time: 4, enemyType: EnemyType.stationary, x: 240),

    // Gate 1
    const SpawnEvent.gate(
      time: 10,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 5),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.2),
    ),

    // Wave 2: patrol enemies
    const SpawnEvent.enemy(time: 14, enemyType: EnemyType.patrol, x: 60),
    const SpawnEvent.enemy(time: 16, enemyType: EnemyType.patrol, x: 260),
    const SpawnEvent.enemy(time: 18, enemyType: EnemyType.stationary, x: 160),

    // Wave 3: mixed
    const SpawnEvent.enemy(time: 24, enemyType: EnemyType.stationary, x: 100),
    const SpawnEvent.enemy(time: 24, enemyType: EnemyType.stationary, x: 220),
    const SpawnEvent.enemy(time: 26, enemyType: EnemyType.patrol, x: 160),

    // Gate 2
    const SpawnEvent.gate(
      time: 32,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 8),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
    ),

    // Wave 4: heavier
    const SpawnEvent.enemy(time: 36, enemyType: EnemyType.patrol, x: 80),
    const SpawnEvent.enemy(time: 36, enemyType: EnemyType.patrol, x: 240),
    const SpawnEvent.enemy(time: 38, enemyType: EnemyType.stationary, x: 160),
    const SpawnEvent.enemy(time: 40, enemyType: EnemyType.patrol, x: 120),
    const SpawnEvent.enemy(time: 40, enemyType: EnemyType.patrol, x: 200),

    // Wave 5: final wave
    const SpawnEvent.enemy(time: 46, enemyType: EnemyType.stationary, x: 60),
    const SpawnEvent.enemy(time: 46, enemyType: EnemyType.stationary, x: 160),
    const SpawnEvent.enemy(time: 46, enemyType: EnemyType.stationary, x: 260),
    const SpawnEvent.enemy(time: 48, enemyType: EnemyType.patrol, x: 100),
    const SpawnEvent.enemy(time: 48, enemyType: EnemyType.patrol, x: 220),

    // Gate 3 (final)
    const SpawnEvent.gate(
      time: 54,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.5),
    ),
  ],
);
