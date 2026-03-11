import 'stage_data.dart';

/// Stage 2: 90 seconds — introduces Rush and Swarm enemies
final stage2 = StageData(
  id: 2,
  name: 'Stage 2',
  duration: 90,
  timeline: [
    // Wave 1: Stationary intro
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.stationary, x: 160),
    const SpawnEvent.enemy(time: 4, enemyType: EnemyType.stationary, x: 80),
    const SpawnEvent.enemy(time: 4, enemyType: EnemyType.stationary, x: 240),

    // Wave 2: Rush introduction
    const SpawnEvent.enemy(time: 10, enemyType: EnemyType.rush, x: 100),
    const SpawnEvent.enemy(time: 11, enemyType: EnemyType.rush, x: 220),
    const SpawnEvent.enemy(time: 12, enemyType: EnemyType.rush, x: 160),

    // Gate 1
    const SpawnEvent.gate(
      time: 16,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 5),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.2),
    ),

    // Wave 3: Patrol + Rush mix
    const SpawnEvent.enemy(time: 20, enemyType: EnemyType.patrol, x: 80),
    const SpawnEvent.enemy(time: 21, enemyType: EnemyType.rush, x: 260),
    const SpawnEvent.enemy(time: 22, enemyType: EnemyType.patrol, x: 200),
    const SpawnEvent.enemy(time: 23, enemyType: EnemyType.rush, x: 60),

    // Wave 4: Swarm introduction (cluster)
    const SpawnEvent.enemy(time: 30, enemyType: EnemyType.swarm, x: 80),
    const SpawnEvent.enemy(time: 30, enemyType: EnemyType.swarm, x: 120),
    const SpawnEvent.enemy(time: 30, enemyType: EnemyType.swarm, x: 160),
    const SpawnEvent.enemy(time: 30, enemyType: EnemyType.swarm, x: 200),
    const SpawnEvent.enemy(time: 30, enemyType: EnemyType.swarm, x: 240),

    // Gate 2
    const SpawnEvent.gate(
      time: 36,
      leftEffect: GateEffect(type: GateEffectType.hpRecover, value: 20),
      rightEffect: GateEffect(type: GateEffectType.atkAdd, value: 8),
    ),

    // Wave 5: Mixed — Stationary + Swarm cluster
    const SpawnEvent.enemy(time: 40, enemyType: EnemyType.stationary, x: 100),
    const SpawnEvent.enemy(time: 40, enemyType: EnemyType.stationary, x: 220),
    const SpawnEvent.enemy(time: 42, enemyType: EnemyType.swarm, x: 100),
    const SpawnEvent.enemy(time: 42, enemyType: EnemyType.swarm, x: 140),
    const SpawnEvent.enemy(time: 42, enemyType: EnemyType.swarm, x: 180),
    const SpawnEvent.enemy(time: 42, enemyType: EnemyType.swarm, x: 220),

    // Wave 6: Rush swarm
    const SpawnEvent.enemy(time: 50, enemyType: EnemyType.rush, x: 60),
    const SpawnEvent.enemy(time: 50.5, enemyType: EnemyType.rush, x: 160),
    const SpawnEvent.enemy(time: 51, enemyType: EnemyType.rush, x: 260),
    const SpawnEvent.enemy(time: 52, enemyType: EnemyType.rush, x: 120),
    const SpawnEvent.enemy(time: 52.5, enemyType: EnemyType.rush, x: 200),

    // Gate 3
    const SpawnEvent.gate(
      time: 58,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
      rightEffect: GateEffect(type: GateEffectType.hpRecover, value: 30),
    ),

    // Wave 7: Heavy mix
    const SpawnEvent.enemy(time: 62, enemyType: EnemyType.patrol, x: 80),
    const SpawnEvent.enemy(time: 62, enemyType: EnemyType.patrol, x: 240),
    const SpawnEvent.enemy(time: 64, enemyType: EnemyType.rush, x: 160),
    const SpawnEvent.enemy(time: 66, enemyType: EnemyType.swarm, x: 60),
    const SpawnEvent.enemy(time: 66, enemyType: EnemyType.swarm, x: 120),
    const SpawnEvent.enemy(time: 66, enemyType: EnemyType.swarm, x: 180),
    const SpawnEvent.enemy(time: 66, enemyType: EnemyType.swarm, x: 240),

    // Wave 8: Final wave — all types
    const SpawnEvent.enemy(time: 74, enemyType: EnemyType.stationary, x: 80),
    const SpawnEvent.enemy(time: 74, enemyType: EnemyType.stationary, x: 240),
    const SpawnEvent.enemy(time: 76, enemyType: EnemyType.patrol, x: 160),
    const SpawnEvent.enemy(time: 78, enemyType: EnemyType.rush, x: 100),
    const SpawnEvent.enemy(time: 78, enemyType: EnemyType.rush, x: 220),
    const SpawnEvent.enemy(time: 80, enemyType: EnemyType.swarm, x: 80),
    const SpawnEvent.enemy(time: 80, enemyType: EnemyType.swarm, x: 160),
    const SpawnEvent.enemy(time: 80, enemyType: EnemyType.swarm, x: 240),

    // Gate 4 (final)
    const SpawnEvent.gate(
      time: 84,
      leftEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.5),
      rightEffect: GateEffect(type: GateEffectType.atkAdd, value: 12),
    ),
  ],
);
