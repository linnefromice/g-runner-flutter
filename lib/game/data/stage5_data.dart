import 'stage_data.dart';

/// Stage 5: 180 seconds — Boss stage (Act 1 finale)
/// Pre-boss waves (0-60s), then Boss spawns at 60s
final stage5 = StageData(
  id: 5,
  name: 'Stage 5 - Core Breach',
  duration: 180,
  hasBoss: true,
  creditReward: 150,
  timeline: [
    // Wave 1: Mixed opening
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.patrol, x: 80),
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.patrol, x: 240),
    const SpawnEvent.enemy(time: 4, enemyType: EnemyType.rush, x: 160),

    // Wave 2: Phalanx + escorts
    const SpawnEvent.enemy(time: 8, enemyType: EnemyType.phalanx, x: 160),
    const SpawnEvent.enemy(time: 10, enemyType: EnemyType.patrol, x: 60),
    const SpawnEvent.enemy(time: 10, enemyType: EnemyType.patrol, x: 260),

    // Gate 1
    const SpawnEvent.gate(
      time: 14,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
      rightEffect: GateEffect(type: GateEffectType.hpRecover, value: 30),
    ),

    // Wave 3: Rush blitz
    const SpawnEvent.enemy(time: 18, enemyType: EnemyType.rush, x: 60),
    const SpawnEvent.enemy(time: 18.5, enemyType: EnemyType.rush, x: 160),
    const SpawnEvent.enemy(time: 19, enemyType: EnemyType.rush, x: 260),
    const SpawnEvent.enemy(time: 20, enemyType: EnemyType.rush, x: 120),
    const SpawnEvent.enemy(time: 20.5, enemyType: EnemyType.rush, x: 200),

    // Wave 4: Swarm cluster + Phalanx
    const SpawnEvent.enemy(time: 26, enemyType: EnemyType.swarm, x: 60),
    const SpawnEvent.enemy(time: 26, enemyType: EnemyType.swarm, x: 100),
    const SpawnEvent.enemy(time: 26, enemyType: EnemyType.swarm, x: 140),
    const SpawnEvent.enemy(time: 26, enemyType: EnemyType.swarm, x: 180),
    const SpawnEvent.enemy(time: 26, enemyType: EnemyType.swarm, x: 220),
    const SpawnEvent.enemy(time: 26, enemyType: EnemyType.swarm, x: 260),
    const SpawnEvent.enemy(time: 28, enemyType: EnemyType.phalanx, x: 100),
    const SpawnEvent.enemy(time: 28, enemyType: EnemyType.phalanx, x: 220),

    // Gate 2
    const SpawnEvent.gate(
      time: 34,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 12),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
    ),

    // Wave 5: Heavy assault
    const SpawnEvent.enemy(time: 38, enemyType: EnemyType.phalanx, x: 80),
    const SpawnEvent.enemy(time: 38, enemyType: EnemyType.phalanx, x: 240),
    const SpawnEvent.enemy(time: 40, enemyType: EnemyType.patrol, x: 160),
    const SpawnEvent.enemy(time: 42, enemyType: EnemyType.rush, x: 80),
    const SpawnEvent.enemy(time: 42, enemyType: EnemyType.rush, x: 240),

    // Gate 3
    const SpawnEvent.gate(
      time: 48,
      leftEffect: GateEffect(type: GateEffectType.hpRecover, value: 40),
      rightEffect: GateEffect(type: GateEffectType.atkAdd, value: 15),
    ),

    // Wave 6: Final pre-boss wave
    const SpawnEvent.enemy(time: 52, enemyType: EnemyType.stationary, x: 80),
    const SpawnEvent.enemy(time: 52, enemyType: EnemyType.stationary, x: 160),
    const SpawnEvent.enemy(time: 52, enemyType: EnemyType.stationary, x: 240),
    const SpawnEvent.enemy(time: 54, enemyType: EnemyType.patrol, x: 120),
    const SpawnEvent.enemy(time: 54, enemyType: EnemyType.patrol, x: 200),

    // Gate 4 (pre-boss boost)
    const SpawnEvent.gate(
      time: 58,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 20),
      rightEffect: GateEffect(type: GateEffectType.hpRecover, value: 50),
    ),

    // === BOSS SPAWN ===
    const SpawnEvent.boss(time: 62),
  ],
);
