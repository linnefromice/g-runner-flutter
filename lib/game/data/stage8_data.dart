import 'stage_data.dart';

/// Stage 8: War Front — Juggernaut + Sentinel, 120秒
final stage8 = StageData(
  id: 8,
  name: 'War Front',
  duration: 120,
  timeline: [
    // Wave 1: Patrol + Phalanx
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.patrol, x: 80),
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.patrol, x: 240),
    const SpawnEvent.enemy(time: 5, enemyType: EnemyType.phalanx, x: 160),

    // Gate 1
    const SpawnEvent.gate(
      time: 12,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.2),
    ),

    // Wave 2: Swarm cluster
    const SpawnEvent.enemy(time: 16, enemyType: EnemyType.swarm, x: 80),
    const SpawnEvent.enemy(time: 16, enemyType: EnemyType.swarm, x: 120),
    const SpawnEvent.enemy(time: 16, enemyType: EnemyType.swarm, x: 160),
    const SpawnEvent.enemy(time: 16, enemyType: EnemyType.swarm, x: 200),
    const SpawnEvent.enemy(time: 16, enemyType: EnemyType.swarm, x: 240),
    const SpawnEvent.enemy(time: 20, enemyType: EnemyType.phalanx, x: 100),
    const SpawnEvent.enemy(time: 20, enemyType: EnemyType.phalanx, x: 220),

    // Wave 3: Juggernaut introduction
    const SpawnEvent.enemy(time: 28, enemyType: EnemyType.juggernaut, x: 160),

    // Gate 2: Tradeoff
    const SpawnEvent.gate(
      time: 36,
      leftEffect: GateEffect(type: GateEffectType.tradeoffAtkUpSpdDown, value: 15, value2: 0.8),
      rightEffect: GateEffect(type: GateEffectType.tradeoffSpdUpAtkDown, value: 1.3, value2: 0.7),
    ),

    // Wave 4: Sentinel introduction
    const SpawnEvent.enemy(time: 42, enemyType: EnemyType.sentinel, x: 160),
    const SpawnEvent.enemy(time: 44, enemyType: EnemyType.patrol, x: 80),
    const SpawnEvent.enemy(time: 44, enemyType: EnemyType.patrol, x: 240),

    // Gate 3: Refit
    const SpawnEvent.gate(
      time: 52,
      leftEffect: GateEffect(type: GateEffectType.refit, value: 1), // → Heavy
      rightEffect: GateEffect(type: GateEffectType.refit, value: 2), // → Speed
    ),

    // Wave 5: Juggernaut + Sentinel combo
    const SpawnEvent.enemy(time: 58, enemyType: EnemyType.juggernaut, x: 120),
    const SpawnEvent.enemy(time: 58, enemyType: EnemyType.sentinel, x: 220),
    const SpawnEvent.enemy(time: 62, enemyType: EnemyType.phalanx, x: 80),
    const SpawnEvent.enemy(time: 62, enemyType: EnemyType.phalanx, x: 240),

    // Gate 4: Extreme tradeoff
    const SpawnEvent.gate(
      time: 72,
      leftEffect: GateEffect(type: GateEffectType.tradeoffAtkUpSpdDown, value: 20, value2: 0.7),
      rightEffect: GateEffect(type: GateEffectType.hpRecover, value: 30),
    ),

    // Wave 6: Heavy assault
    const SpawnEvent.enemy(time: 78, enemyType: EnemyType.juggernaut, x: 80),
    const SpawnEvent.enemy(time: 78, enemyType: EnemyType.juggernaut, x: 240),
    const SpawnEvent.enemy(time: 82, enemyType: EnemyType.swarm, x: 120),
    const SpawnEvent.enemy(time: 82, enemyType: EnemyType.swarm, x: 160),
    const SpawnEvent.enemy(time: 82, enemyType: EnemyType.swarm, x: 200),
    const SpawnEvent.enemy(time: 86, enemyType: EnemyType.sentinel, x: 160),

    // Gate 5: Strong enhance
    const SpawnEvent.gate(
      time: 96,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 15),
      rightEffect: GateEffect(type: GateEffectType.hpRecover, value: 15),
    ),

    // Wave 7: Final wave
    const SpawnEvent.enemy(time: 100, enemyType: EnemyType.patrol, x: 60),
    const SpawnEvent.enemy(time: 100, enemyType: EnemyType.patrol, x: 260),
    const SpawnEvent.enemy(time: 104, enemyType: EnemyType.juggernaut, x: 160),
    const SpawnEvent.enemy(time: 106, enemyType: EnemyType.phalanx, x: 100),
    const SpawnEvent.enemy(time: 106, enemyType: EnemyType.phalanx, x: 220),
  ],
);
