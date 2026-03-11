import 'stage_data.dart';

/// Stage 6: Scrap Yard — Swarm大群, 100秒
final stage6 = StageData(
  id: 6,
  name: 'Scrap Yard',
  duration: 100,
  timeline: [
    // Wave 1: Patrol opener
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.patrol, x: 80),
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.patrol, x: 240),
    const SpawnEvent.enemy(time: 5, enemyType: EnemyType.stationary, x: 160),

    // Gate 1: Enhance
    const SpawnEvent.gate(
      time: 10,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 5),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.2),
    ),

    // Wave 2: Swarm introduction
    const SpawnEvent.enemy(time: 14, enemyType: EnemyType.swarm, x: 80),
    const SpawnEvent.enemy(time: 14, enemyType: EnemyType.swarm, x: 120),
    const SpawnEvent.enemy(time: 14, enemyType: EnemyType.swarm, x: 160),
    const SpawnEvent.enemy(time: 14, enemyType: EnemyType.swarm, x: 200),
    const SpawnEvent.enemy(time: 14, enemyType: EnemyType.swarm, x: 240),
    const SpawnEvent.enemy(time: 18, enemyType: EnemyType.patrol, x: 100),
    const SpawnEvent.enemy(time: 18, enemyType: EnemyType.patrol, x: 220),

    // Gate 2: Tradeoff
    const SpawnEvent.gate(
      time: 26,
      leftEffect: GateEffect(type: GateEffectType.tradeoffAtkUpSpdDown, value: 15, value2: 0.8),
      rightEffect: GateEffect(type: GateEffectType.tradeoffSpdUpAtkDown, value: 1.3, value2: 0.7),
    ),

    // Wave 3: Dense swarm
    const SpawnEvent.enemy(time: 30, enemyType: EnemyType.swarm, x: 60),
    const SpawnEvent.enemy(time: 30, enemyType: EnemyType.swarm, x: 100),
    const SpawnEvent.enemy(time: 30, enemyType: EnemyType.swarm, x: 140),
    const SpawnEvent.enemy(time: 30, enemyType: EnemyType.swarm, x: 180),
    const SpawnEvent.enemy(time: 30, enemyType: EnemyType.swarm, x: 220),
    const SpawnEvent.enemy(time: 30, enemyType: EnemyType.swarm, x: 260),
    const SpawnEvent.enemy(time: 33, enemyType: EnemyType.stationary, x: 80),
    const SpawnEvent.enemy(time: 33, enemyType: EnemyType.stationary, x: 240),

    // Gate 3: Refit
    const SpawnEvent.gate(
      time: 42,
      leftEffect: GateEffect(type: GateEffectType.refit, value: 1), // → Heavy
      rightEffect: GateEffect(type: GateEffectType.refit, value: 2), // → Speed
    ),

    // Wave 4: Mixed
    const SpawnEvent.enemy(time: 48, enemyType: EnemyType.patrol, x: 60),
    const SpawnEvent.enemy(time: 48, enemyType: EnemyType.patrol, x: 260),
    const SpawnEvent.enemy(time: 50, enemyType: EnemyType.swarm, x: 100),
    const SpawnEvent.enemy(time: 50, enemyType: EnemyType.swarm, x: 160),
    const SpawnEvent.enemy(time: 50, enemyType: EnemyType.swarm, x: 220),
    const SpawnEvent.enemy(time: 53, enemyType: EnemyType.rush, x: 160),
    const SpawnEvent.enemy(time: 55, enemyType: EnemyType.rush, x: 80),
    const SpawnEvent.enemy(time: 55, enemyType: EnemyType.rush, x: 240),

    // Gate 4: Enhance
    const SpawnEvent.gate(
      time: 64,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
      rightEffect: GateEffect(type: GateEffectType.hpRecover, value: 20),
    ),

    // Wave 5: Final
    const SpawnEvent.enemy(time: 70, enemyType: EnemyType.patrol, x: 80),
    const SpawnEvent.enemy(time: 70, enemyType: EnemyType.patrol, x: 240),
    const SpawnEvent.enemy(time: 72, enemyType: EnemyType.swarm, x: 80),
    const SpawnEvent.enemy(time: 72, enemyType: EnemyType.swarm, x: 120),
    const SpawnEvent.enemy(time: 72, enemyType: EnemyType.swarm, x: 160),
    const SpawnEvent.enemy(time: 72, enemyType: EnemyType.swarm, x: 200),
    const SpawnEvent.enemy(time: 72, enemyType: EnemyType.swarm, x: 240),
    const SpawnEvent.enemy(time: 76, enemyType: EnemyType.stationary, x: 100),
    const SpawnEvent.enemy(time: 76, enemyType: EnemyType.stationary, x: 220),
    const SpawnEvent.enemy(time: 80, enemyType: EnemyType.patrol, x: 160),

    // Gate 5: Recovery
    const SpawnEvent.gate(
      time: 90,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 5),
      rightEffect: GateEffect(type: GateEffectType.hpRecover, value: 20),
    ),
  ],
);
