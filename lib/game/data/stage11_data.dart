import 'stage_data.dart';

/// Stage 11: Phantom Zone — Dodger focus, 110秒
final stage11 = StageData(
  id: 11,
  name: 'Phantom Zone',
  duration: 110,
  creditReward: 50,
  timeline: [
    // Wave 1: Opener
    const SpawnEvent.enemy(time: 3, enemyType: EnemyType.patrol, x: 100),
    const SpawnEvent.enemy(time: 5, enemyType: EnemyType.stationary, x: 220),
    const SpawnEvent.enemy(time: 8, enemyType: EnemyType.patrol, x: 160),

    // Gate 1: Enhance
    const SpawnEvent.gate(
      time: 14,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 15),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
    ),

    // Wave 2: Dodger intro
    const SpawnEvent.enemy(time: 19, enemyType: EnemyType.dodger, x: 160),
    const SpawnEvent.enemy(time: 22, enemyType: EnemyType.patrol, x: 80),
    const SpawnEvent.enemy(time: 24, enemyType: EnemyType.dodger, x: 240),

    // Gate 2: Recovery
    const SpawnEvent.gate(
      time: 30,
      leftEffect: GateEffect(type: GateEffectType.hpRecover, value: 20),
      rightEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
    ),

    // Wave 3: Dodger pair
    const SpawnEvent.enemy(time: 36, enemyType: EnemyType.dodger, x: 120),
    const SpawnEvent.enemy(time: 37, enemyType: EnemyType.stationary, x: 200),
    const SpawnEvent.enemy(time: 39, enemyType: EnemyType.dodger, x: 160),

    // Gate 3: Tradeoff
    const SpawnEvent.gate(
      time: 47,
      leftEffect: GateEffect(type: GateEffectType.tradeoffAtkUpSpdDown, value: 20, value2: 0.7),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.4),
    ),

    // Wave 4: Dodger + Swarm
    const SpawnEvent.enemy(time: 54, enemyType: EnemyType.dodger, x: 80),
    const SpawnEvent.enemy(time: 54, enemyType: EnemyType.dodger, x: 240),
    const SpawnEvent.enemy(time: 57, enemyType: EnemyType.patrol, x: 160),
    const SpawnEvent.enemy(time: 59, enemyType: EnemyType.swarm, x: 100),
    const SpawnEvent.enemy(time: 59, enemyType: EnemyType.swarm, x: 140),
    const SpawnEvent.enemy(time: 59, enemyType: EnemyType.swarm, x: 180),
    const SpawnEvent.enemy(time: 59, enemyType: EnemyType.swarm, x: 220),

    // Gate 4: Refit
    const SpawnEvent.gate(
      time: 65,
      leftEffect: GateEffect(type: GateEffectType.refit, value: 1), // → Heavy
      rightEffect: GateEffect(type: GateEffectType.refit, value: 2), // → Speed
    ),

    // Wave 5: Triple dodger
    const SpawnEvent.enemy(time: 72, enemyType: EnemyType.dodger, x: 100),
    const SpawnEvent.enemy(time: 72, enemyType: EnemyType.dodger, x: 220),
    const SpawnEvent.enemy(time: 75, enemyType: EnemyType.patrol, x: 160),
    const SpawnEvent.enemy(time: 77, enemyType: EnemyType.stationary, x: 60),

    // Gate 5: Recovery
    const SpawnEvent.gate(
      time: 83,
      leftEffect: GateEffect(type: GateEffectType.hpRecover, value: 15),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.2),
    ),

    // Wave 6: Final dodger wave
    const SpawnEvent.enemy(time: 88, enemyType: EnemyType.dodger, x: 80),
    const SpawnEvent.enemy(time: 88, enemyType: EnemyType.dodger, x: 160),
    const SpawnEvent.enemy(time: 88, enemyType: EnemyType.dodger, x: 240),
    const SpawnEvent.enemy(time: 92, enemyType: EnemyType.patrol, x: 120),
    const SpawnEvent.enemy(time: 94, enemyType: EnemyType.swarm, x: 160),
    const SpawnEvent.enemy(time: 94, enemyType: EnemyType.swarm, x: 200),
    const SpawnEvent.enemy(time: 94, enemyType: EnemyType.swarm, x: 240),
    const SpawnEvent.enemy(time: 94, enemyType: EnemyType.swarm, x: 120),
    const SpawnEvent.enemy(time: 94, enemyType: EnemyType.swarm, x: 80),

    // Gate 6: Final enhance
    const SpawnEvent.gate(
      time: 100,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
    ),
  ],
);
