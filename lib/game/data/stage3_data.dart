import 'stage_data.dart';

/// Stage 3: 90 seconds — Patrol + Phalanx focused, Swarm waves mixed in
final stage3 = StageData(
  id: 3,
  name: 'Stage 3',
  duration: 90,
  timeline: [
    // Wave 1: Patrol pair
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.patrol, x: 80),
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.patrol, x: 240),
    const SpawnEvent.enemy(time: 5, enemyType: EnemyType.stationary, x: 160),

    // Wave 2: Phalanx introduction
    const SpawnEvent.enemy(time: 10, enemyType: EnemyType.phalanx, x: 160),

    // Gate 1
    const SpawnEvent.gate(
      time: 16,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 8),
      rightEffect: GateEffect(type: GateEffectType.hpRecover, value: 20),
    ),

    // Wave 3: Phalanx + Patrol
    const SpawnEvent.enemy(time: 20, enemyType: EnemyType.phalanx, x: 100),
    const SpawnEvent.enemy(time: 21, enemyType: EnemyType.patrol, x: 240),
    const SpawnEvent.enemy(time: 23, enemyType: EnemyType.patrol, x: 80),

    // Wave 4: Swarm cluster
    const SpawnEvent.enemy(time: 28, enemyType: EnemyType.swarm, x: 60),
    const SpawnEvent.enemy(time: 28, enemyType: EnemyType.swarm, x: 100),
    const SpawnEvent.enemy(time: 28, enemyType: EnemyType.swarm, x: 140),
    const SpawnEvent.enemy(time: 28, enemyType: EnemyType.swarm, x: 180),
    const SpawnEvent.enemy(time: 28, enemyType: EnemyType.swarm, x: 220),
    const SpawnEvent.enemy(time: 28, enemyType: EnemyType.swarm, x: 260),

    // Gate 2
    const SpawnEvent.gate(
      time: 34,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
    ),

    // Wave 5: Double Phalanx
    const SpawnEvent.enemy(time: 38, enemyType: EnemyType.phalanx, x: 100),
    const SpawnEvent.enemy(time: 38, enemyType: EnemyType.phalanx, x: 220),

    // Wave 6: Patrol + Rush combo
    const SpawnEvent.enemy(time: 44, enemyType: EnemyType.patrol, x: 160),
    const SpawnEvent.enemy(time: 46, enemyType: EnemyType.rush, x: 80),
    const SpawnEvent.enemy(time: 46, enemyType: EnemyType.rush, x: 240),
    const SpawnEvent.enemy(time: 48, enemyType: EnemyType.rush, x: 160),

    // Gate 3
    const SpawnEvent.gate(
      time: 52,
      leftEffect: GateEffect(type: GateEffectType.hpRecover, value: 30),
      rightEffect: GateEffect(type: GateEffectType.atkAdd, value: 12),
    ),

    // Wave 7: Phalanx wall + Swarm
    const SpawnEvent.enemy(time: 56, enemyType: EnemyType.phalanx, x: 80),
    const SpawnEvent.enemy(time: 56, enemyType: EnemyType.phalanx, x: 240),
    const SpawnEvent.enemy(time: 58, enemyType: EnemyType.swarm, x: 120),
    const SpawnEvent.enemy(time: 58, enemyType: EnemyType.swarm, x: 160),
    const SpawnEvent.enemy(time: 58, enemyType: EnemyType.swarm, x: 200),

    // Wave 8: Heavy assault
    const SpawnEvent.enemy(time: 64, enemyType: EnemyType.patrol, x: 60),
    const SpawnEvent.enemy(time: 64, enemyType: EnemyType.patrol, x: 260),
    const SpawnEvent.enemy(time: 66, enemyType: EnemyType.phalanx, x: 160),
    const SpawnEvent.enemy(time: 68, enemyType: EnemyType.rush, x: 100),
    const SpawnEvent.enemy(time: 68, enemyType: EnemyType.rush, x: 220),

    // Wave 9: Final wave
    const SpawnEvent.enemy(time: 74, enemyType: EnemyType.phalanx, x: 100),
    const SpawnEvent.enemy(time: 74, enemyType: EnemyType.phalanx, x: 220),
    const SpawnEvent.enemy(time: 76, enemyType: EnemyType.patrol, x: 160),
    const SpawnEvent.enemy(time: 78, enemyType: EnemyType.swarm, x: 60),
    const SpawnEvent.enemy(time: 78, enemyType: EnemyType.swarm, x: 120),
    const SpawnEvent.enemy(time: 78, enemyType: EnemyType.swarm, x: 180),
    const SpawnEvent.enemy(time: 78, enemyType: EnemyType.swarm, x: 240),

    // Gate 4 (final)
    const SpawnEvent.gate(
      time: 84,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 15),
      rightEffect: GateEffect(type: GateEffectType.hpRecover, value: 40),
    ),
  ],
);
