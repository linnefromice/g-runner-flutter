import 'stage_data.dart';

/// Stage 12: Hive Cluster — Splitter chain-splits, 120秒
final stage12 = StageData(
  id: 12,
  name: 'Hive Cluster',
  duration: 120,
  creditReward: 50,
  timeline: [
    // Wave 1: Patrol opener
    const SpawnEvent.enemy(time: 3, enemyType: EnemyType.patrol, x: 100),
    const SpawnEvent.enemy(time: 6, enemyType: EnemyType.patrol, x: 240),
    const SpawnEvent.enemy(time: 10, enemyType: EnemyType.splitter, x: 160),

    // Gate 1: Strong enhance
    const SpawnEvent.gate(
      time: 16,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 15),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
    ),

    // Wave 2: Splitter + Swarm
    const SpawnEvent.enemy(time: 21, enemyType: EnemyType.splitter, x: 100),
    const SpawnEvent.enemy(time: 23, enemyType: EnemyType.swarm, x: 180),
    const SpawnEvent.enemy(time: 23, enemyType: EnemyType.swarm, x: 200),
    const SpawnEvent.enemy(time: 23, enemyType: EnemyType.swarm, x: 220),
    const SpawnEvent.enemy(time: 23, enemyType: EnemyType.swarm, x: 240),
    const SpawnEvent.enemy(time: 26, enemyType: EnemyType.splitter, x: 240),

    // Gate 2: Growth
    const SpawnEvent.gate(
      time: 32,
      leftEffect: GateEffect(type: GateEffectType.growth, value: 5),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.2),
    ),

    // Wave 3: Double splitter
    const SpawnEvent.enemy(time: 38, enemyType: EnemyType.splitter, x: 80),
    const SpawnEvent.enemy(time: 38, enemyType: EnemyType.splitter, x: 240),
    const SpawnEvent.enemy(time: 42, enemyType: EnemyType.patrol, x: 160),

    // Gate 3: Recovery
    const SpawnEvent.gate(
      time: 49,
      leftEffect: GateEffect(type: GateEffectType.hpRecover, value: 20),
      rightEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
    ),

    // Wave 4: Triple splitter + Sentinel mini-boss
    const SpawnEvent.enemy(time: 54, enemyType: EnemyType.splitter, x: 80),
    const SpawnEvent.enemy(time: 55, enemyType: EnemyType.splitter, x: 160),
    const SpawnEvent.enemy(time: 56, enemyType: EnemyType.splitter, x: 240),
    const SpawnEvent.enemy(time: 59, enemyType: EnemyType.swarm, x: 100),
    const SpawnEvent.enemy(time: 59, enemyType: EnemyType.swarm, x: 140),
    const SpawnEvent.enemy(time: 59, enemyType: EnemyType.swarm, x: 180),
    const SpawnEvent.enemy(time: 59, enemyType: EnemyType.swarm, x: 220),
    const SpawnEvent.enemy(time: 59, enemyType: EnemyType.swarm, x: 260),
    const SpawnEvent.enemy(time: 59, enemyType: EnemyType.swarm, x: 60),
    const SpawnEvent.enemy(time: 60, enemyType: EnemyType.sentinel, x: 160),

    // Gate 4: Roulette
    const SpawnEvent.gate(
      time: 65,
      leftEffect: GateEffect(type: GateEffectType.roulette, value: 15, value2: -10),
      rightEffect: GateEffect(type: GateEffectType.tradeoffAtkUpSpdDown, value: 15, value2: 0.8),
    ),

    // Wave 5: Phalanx wall + Splitter
    const SpawnEvent.enemy(time: 70, enemyType: EnemyType.phalanx, x: 100),
    const SpawnEvent.enemy(time: 70, enemyType: EnemyType.phalanx, x: 220),
    const SpawnEvent.enemy(time: 73, enemyType: EnemyType.splitter, x: 160),

    // Gate 5: Refit
    const SpawnEvent.gate(
      time: 81,
      leftEffect: GateEffect(type: GateEffectType.refit, value: 1), // → Heavy
      rightEffect: GateEffect(type: GateEffectType.refit, value: 2), // → Speed
    ),

    // Wave 6: Juggernaut + Splitter swarm
    const SpawnEvent.enemy(time: 86, enemyType: EnemyType.juggernaut, x: 160),
    const SpawnEvent.enemy(time: 88, enemyType: EnemyType.splitter, x: 80),
    const SpawnEvent.enemy(time: 88, enemyType: EnemyType.splitter, x: 240),
    const SpawnEvent.enemy(time: 91, enemyType: EnemyType.swarm, x: 120),
    const SpawnEvent.enemy(time: 91, enemyType: EnemyType.swarm, x: 160),
    const SpawnEvent.enemy(time: 91, enemyType: EnemyType.swarm, x: 200),
    const SpawnEvent.enemy(time: 91, enemyType: EnemyType.swarm, x: 240),
    const SpawnEvent.enemy(time: 91, enemyType: EnemyType.swarm, x: 80),

    // Gate 6: Recovery
    const SpawnEvent.gate(
      time: 97,
      leftEffect: GateEffect(type: GateEffectType.hpRecover, value: 15),
      rightEffect: GateEffect(type: GateEffectType.atkAdd, value: 15),
    ),

    // Wave 7: Final wave
    const SpawnEvent.enemy(time: 103, enemyType: EnemyType.splitter, x: 60),
    const SpawnEvent.enemy(time: 103, enemyType: EnemyType.splitter, x: 160),
    const SpawnEvent.enemy(time: 103, enemyType: EnemyType.splitter, x: 260),
    const SpawnEvent.enemy(time: 106, enemyType: EnemyType.patrol, x: 120),
    const SpawnEvent.enemy(time: 108, enemyType: EnemyType.patrol, x: 200),

    // Gate 7: Final enhance
    const SpawnEvent.gate(
      time: 113,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
    ),
  ],
);
