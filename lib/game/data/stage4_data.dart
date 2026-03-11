import 'stage_data.dart';

/// Stage 4: 90 seconds — all 5 enemy types, high density, pre-boss preparation
final stage4 = StageData(
  id: 4,
  name: 'Stage 4',
  duration: 90,
  timeline: [
    // Wave 1: Rush pair opening
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.rush, x: 80),
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.rush, x: 240),
    const SpawnEvent.enemy(time: 3, enemyType: EnemyType.rush, x: 160),

    // Wave 2: Patrol + Stationary formation
    const SpawnEvent.enemy(time: 8, enemyType: EnemyType.stationary, x: 80),
    const SpawnEvent.enemy(time: 8, enemyType: EnemyType.stationary, x: 160),
    const SpawnEvent.enemy(time: 8, enemyType: EnemyType.stationary, x: 240),
    const SpawnEvent.enemy(time: 10, enemyType: EnemyType.patrol, x: 120),
    const SpawnEvent.enemy(time: 10, enemyType: EnemyType.patrol, x: 200),

    // Gate 1
    const SpawnEvent.gate(
      time: 14,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
    ),

    // Wave 3: Phalanx + Rush
    const SpawnEvent.enemy(time: 18, enemyType: EnemyType.phalanx, x: 160),
    const SpawnEvent.enemy(time: 20, enemyType: EnemyType.rush, x: 60),
    const SpawnEvent.enemy(time: 20, enemyType: EnemyType.rush, x: 260),

    // Wave 4: Swarm flood
    const SpawnEvent.enemy(time: 26, enemyType: EnemyType.swarm, x: 40),
    const SpawnEvent.enemy(time: 26, enemyType: EnemyType.swarm, x: 80),
    const SpawnEvent.enemy(time: 26, enemyType: EnemyType.swarm, x: 120),
    const SpawnEvent.enemy(time: 26, enemyType: EnemyType.swarm, x: 160),
    const SpawnEvent.enemy(time: 26, enemyType: EnemyType.swarm, x: 200),
    const SpawnEvent.enemy(time: 26, enemyType: EnemyType.swarm, x: 240),
    const SpawnEvent.enemy(time: 26, enemyType: EnemyType.swarm, x: 280),

    // Gate 2
    const SpawnEvent.gate(
      time: 32,
      leftEffect: GateEffect(type: GateEffectType.hpRecover, value: 30),
      rightEffect: GateEffect(type: GateEffectType.atkAdd, value: 12),
    ),

    // Wave 5: Double Phalanx + Patrol escorts
    const SpawnEvent.enemy(time: 36, enemyType: EnemyType.phalanx, x: 80),
    const SpawnEvent.enemy(time: 36, enemyType: EnemyType.phalanx, x: 240),
    const SpawnEvent.enemy(time: 38, enemyType: EnemyType.patrol, x: 160),
    const SpawnEvent.enemy(time: 40, enemyType: EnemyType.patrol, x: 100),
    const SpawnEvent.enemy(time: 40, enemyType: EnemyType.patrol, x: 220),

    // Wave 6: Rush blitz
    const SpawnEvent.enemy(time: 46, enemyType: EnemyType.rush, x: 60),
    const SpawnEvent.enemy(time: 46.5, enemyType: EnemyType.rush, x: 120),
    const SpawnEvent.enemy(time: 47, enemyType: EnemyType.rush, x: 200),
    const SpawnEvent.enemy(time: 47.5, enemyType: EnemyType.rush, x: 260),
    const SpawnEvent.enemy(time: 48, enemyType: EnemyType.rush, x: 160),

    // Gate 3
    const SpawnEvent.gate(
      time: 52,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 15),
      rightEffect: GateEffect(type: GateEffectType.hpRecover, value: 40),
    ),

    // Wave 7: All types mixed
    const SpawnEvent.enemy(time: 56, enemyType: EnemyType.phalanx, x: 160),
    const SpawnEvent.enemy(time: 58, enemyType: EnemyType.stationary, x: 60),
    const SpawnEvent.enemy(time: 58, enemyType: EnemyType.stationary, x: 260),
    const SpawnEvent.enemy(time: 60, enemyType: EnemyType.rush, x: 120),
    const SpawnEvent.enemy(time: 60, enemyType: EnemyType.rush, x: 200),
    const SpawnEvent.enemy(time: 62, enemyType: EnemyType.swarm, x: 80),
    const SpawnEvent.enemy(time: 62, enemyType: EnemyType.swarm, x: 160),
    const SpawnEvent.enemy(time: 62, enemyType: EnemyType.swarm, x: 240),
    const SpawnEvent.enemy(time: 64, enemyType: EnemyType.patrol, x: 100),
    const SpawnEvent.enemy(time: 64, enemyType: EnemyType.patrol, x: 220),

    // Wave 8: High-density final wave
    const SpawnEvent.enemy(time: 70, enemyType: EnemyType.phalanx, x: 80),
    const SpawnEvent.enemy(time: 70, enemyType: EnemyType.phalanx, x: 240),
    const SpawnEvent.enemy(time: 72, enemyType: EnemyType.patrol, x: 160),
    const SpawnEvent.enemy(time: 74, enemyType: EnemyType.rush, x: 60),
    const SpawnEvent.enemy(time: 74, enemyType: EnemyType.rush, x: 260),
    const SpawnEvent.enemy(time: 76, enemyType: EnemyType.swarm, x: 80),
    const SpawnEvent.enemy(time: 76, enemyType: EnemyType.swarm, x: 120),
    const SpawnEvent.enemy(time: 76, enemyType: EnemyType.swarm, x: 160),
    const SpawnEvent.enemy(time: 76, enemyType: EnemyType.swarm, x: 200),
    const SpawnEvent.enemy(time: 76, enemyType: EnemyType.swarm, x: 240),
    const SpawnEvent.enemy(time: 78, enemyType: EnemyType.phalanx, x: 160),

    // Gate 4 (final)
    const SpawnEvent.gate(
      time: 84,
      leftEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.5),
      rightEffect: GateEffect(type: GateEffectType.atkAdd, value: 20),
    ),
  ],
);
