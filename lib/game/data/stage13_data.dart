import 'stage_data.dart';

/// Stage 13: Command Nexus — Summoner + Phalanx fortress, 120秒
final stage13 = StageData(
  id: 13,
  name: 'Command Nexus',
  duration: 120,
  creditReward: 50,
  timeline: [
    // Wave 1: Phalanx wall opener
    const SpawnEvent.enemy(time: 3, enemyType: EnemyType.phalanx, x: 100),
    const SpawnEvent.enemy(time: 3, enemyType: EnemyType.phalanx, x: 220),
    const SpawnEvent.enemy(time: 6, enemyType: EnemyType.patrol, x: 160),

    // Wave 2: Summoner intro
    const SpawnEvent.enemy(time: 12, enemyType: EnemyType.summoner, x: 160),
    const SpawnEvent.enemy(time: 12, enemyType: EnemyType.phalanx, x: 100),

    // Gate 1: Act 3 enhance
    const SpawnEvent.gate(
      time: 18,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 20),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
    ),

    // Wave 3: Summoner + Dodger
    const SpawnEvent.enemy(time: 23, enemyType: EnemyType.summoner, x: 80),
    const SpawnEvent.enemy(time: 25, enemyType: EnemyType.dodger, x: 220),
    const SpawnEvent.enemy(time: 27, enemyType: EnemyType.patrol, x: 160),

    // Gate 2: Recovery
    const SpawnEvent.gate(
      time: 33,
      leftEffect: GateEffect(type: GateEffectType.hpRecover, value: 20),
      rightEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
    ),

    // Wave 4: Phalanx triple wall
    const SpawnEvent.enemy(time: 39, enemyType: EnemyType.phalanx, x: 80),
    const SpawnEvent.enemy(time: 39, enemyType: EnemyType.phalanx, x: 160),
    const SpawnEvent.enemy(time: 39, enemyType: EnemyType.phalanx, x: 240),
    const SpawnEvent.enemy(time: 41, enemyType: EnemyType.summoner, x: 160),

    // Gate 3: Refit Guardian
    const SpawnEvent.gate(
      time: 49,
      leftEffect: GateEffect(type: GateEffectType.refit, value: 5), // → Guardian
      rightEffect: GateEffect(type: GateEffectType.refit, value: 2), // → Speed
    ),

    // Wave 5: Double Summoner
    const SpawnEvent.enemy(time: 56, enemyType: EnemyType.summoner, x: 80),
    const SpawnEvent.enemy(time: 56, enemyType: EnemyType.summoner, x: 240),
    const SpawnEvent.enemy(time: 59, enemyType: EnemyType.swarm, x: 120),
    const SpawnEvent.enemy(time: 59, enemyType: EnemyType.swarm, x: 160),
    const SpawnEvent.enemy(time: 59, enemyType: EnemyType.swarm, x: 200),
    const SpawnEvent.enemy(time: 59, enemyType: EnemyType.swarm, x: 240),
    const SpawnEvent.enemy(time: 59, enemyType: EnemyType.swarm, x: 80),

    // Gate 4: Tradeoff
    const SpawnEvent.gate(
      time: 65,
      leftEffect: GateEffect(type: GateEffectType.tradeoffAtkUpSpdDown, value: 25, value2: 0.7),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.5),
    ),

    // Wave 6: Juggernaut + Summoner
    const SpawnEvent.enemy(time: 70, enemyType: EnemyType.juggernaut, x: 160),
    const SpawnEvent.enemy(time: 72, enemyType: EnemyType.summoner, x: 80),
    const SpawnEvent.enemy(time: 74, enemyType: EnemyType.dodger, x: 240),

    // Gate 5: Recovery + Growth
    const SpawnEvent.gate(
      time: 82,
      leftEffect: GateEffect(type: GateEffectType.hpRecover, value: 15),
      rightEffect: GateEffect(type: GateEffectType.growth, value: 5),
    ),

    // Wave 7: Triple Summoner
    const SpawnEvent.enemy(time: 87, enemyType: EnemyType.summoner, x: 60),
    const SpawnEvent.enemy(time: 87, enemyType: EnemyType.summoner, x: 160),
    const SpawnEvent.enemy(time: 87, enemyType: EnemyType.summoner, x: 260),
    const SpawnEvent.enemy(time: 90, enemyType: EnemyType.phalanx, x: 120),
    const SpawnEvent.enemy(time: 90, enemyType: EnemyType.phalanx, x: 200),

    // Gate 6: Strong enhance
    const SpawnEvent.gate(
      time: 96,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 20),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
    ),

    // Wave 8: Final wave
    const SpawnEvent.enemy(time: 101, enemyType: EnemyType.summoner, x: 160),
    const SpawnEvent.enemy(time: 103, enemyType: EnemyType.dodger, x: 80),
    const SpawnEvent.enemy(time: 103, enemyType: EnemyType.dodger, x: 240),
    const SpawnEvent.enemy(time: 106, enemyType: EnemyType.patrol, x: 160),

    // Gate 7: Final
    const SpawnEvent.gate(
      time: 112,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.2),
    ),
  ],
);
