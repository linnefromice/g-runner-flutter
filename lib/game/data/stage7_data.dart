import 'stage_data.dart';

/// Stage 7: Fortress Gate — Phalanx壁, 110秒
final stage7 = StageData(
  id: 7,
  name: 'Fortress Gate',
  duration: 110,
  timeline: [
    // Wave 1: Patrol + Stationary
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.patrol, x: 100),
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.patrol, x: 220),
    const SpawnEvent.enemy(time: 5, enemyType: EnemyType.stationary, x: 60),
    const SpawnEvent.enemy(time: 5, enemyType: EnemyType.stationary, x: 260),

    // Gate 1: Strong enhance
    const SpawnEvent.gate(
      time: 12,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 15),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
    ),

    // Wave 2: Swarm + Patrol
    const SpawnEvent.enemy(time: 16, enemyType: EnemyType.swarm, x: 80),
    const SpawnEvent.enemy(time: 16, enemyType: EnemyType.swarm, x: 120),
    const SpawnEvent.enemy(time: 16, enemyType: EnemyType.swarm, x: 200),
    const SpawnEvent.enemy(time: 16, enemyType: EnemyType.swarm, x: 240),
    const SpawnEvent.enemy(time: 20, enemyType: EnemyType.patrol, x: 160),

    // Wave 3: Phalanx introduction
    const SpawnEvent.enemy(time: 28, enemyType: EnemyType.phalanx, x: 160),
    const SpawnEvent.enemy(time: 30, enemyType: EnemyType.stationary, x: 80),
    const SpawnEvent.enemy(time: 30, enemyType: EnemyType.stationary, x: 240),

    // Gate 2: Tradeoff
    const SpawnEvent.gate(
      time: 38,
      leftEffect: GateEffect(type: GateEffectType.tradeoffAtkUpSpdDown, value: 15, value2: 0.8),
      rightEffect: GateEffect(type: GateEffectType.tradeoffSpdUpAtkDown, value: 1.3, value2: 0.7),
    ),

    // Wave 4: Double Phalanx
    const SpawnEvent.enemy(time: 44, enemyType: EnemyType.phalanx, x: 100),
    const SpawnEvent.enemy(time: 44, enemyType: EnemyType.phalanx, x: 220),
    const SpawnEvent.enemy(time: 48, enemyType: EnemyType.patrol, x: 160),

    // Gate 3: Refit
    const SpawnEvent.gate(
      time: 56,
      leftEffect: GateEffect(type: GateEffectType.refit, value: 1), // → Heavy
      rightEffect: GateEffect(type: GateEffectType.refit, value: 2), // → Speed
    ),

    // Wave 5: Phalanx wall + Rush
    const SpawnEvent.enemy(time: 62, enemyType: EnemyType.phalanx, x: 80),
    const SpawnEvent.enemy(time: 62, enemyType: EnemyType.phalanx, x: 160),
    const SpawnEvent.enemy(time: 62, enemyType: EnemyType.phalanx, x: 240),
    const SpawnEvent.enemy(time: 66, enemyType: EnemyType.rush, x: 120),
    const SpawnEvent.enemy(time: 66, enemyType: EnemyType.rush, x: 200),

    // Gate 4: Extreme tradeoff
    const SpawnEvent.gate(
      time: 76,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
      rightEffect: GateEffect(type: GateEffectType.hpRecover, value: 15),
    ),

    // Wave 6: Final
    const SpawnEvent.enemy(time: 82, enemyType: EnemyType.phalanx, x: 160),
    const SpawnEvent.enemy(time: 84, enemyType: EnemyType.patrol, x: 80),
    const SpawnEvent.enemy(time: 84, enemyType: EnemyType.patrol, x: 240),
    const SpawnEvent.enemy(time: 88, enemyType: EnemyType.swarm, x: 100),
    const SpawnEvent.enemy(time: 88, enemyType: EnemyType.swarm, x: 140),
    const SpawnEvent.enemy(time: 88, enemyType: EnemyType.swarm, x: 180),
    const SpawnEvent.enemy(time: 88, enemyType: EnemyType.swarm, x: 220),

    // Gate 5
    const SpawnEvent.gate(
      time: 100,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 15),
      rightEffect: GateEffect(type: GateEffectType.hpRecover, value: 15),
    ),
  ],
);
