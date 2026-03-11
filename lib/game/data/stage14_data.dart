import 'stage_data.dart';

/// Stage 14: Chaos Corridor — All enemy types, high intensity, 130秒
final stage14 = StageData(
  id: 14,
  name: 'Chaos Corridor',
  duration: 130,
  creditReward: 50,
  timeline: [
    // Wave 1: Double patrol + Dodger
    const SpawnEvent.enemy(time: 3, enemyType: EnemyType.patrol, x: 80),
    const SpawnEvent.enemy(time: 3, enemyType: EnemyType.patrol, x: 240),
    const SpawnEvent.enemy(time: 5, enemyType: EnemyType.dodger, x: 160),
    const SpawnEvent.enemy(time: 7, enemyType: EnemyType.swarm, x: 100),
    const SpawnEvent.enemy(time: 7, enemyType: EnemyType.swarm, x: 140),
    const SpawnEvent.enemy(time: 7, enemyType: EnemyType.swarm, x: 180),
    const SpawnEvent.enemy(time: 7, enemyType: EnemyType.swarm, x: 220),
    const SpawnEvent.enemy(time: 7, enemyType: EnemyType.swarm, x: 260),

    // Gate 1: Act 3 enhance
    const SpawnEvent.gate(
      time: 13,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 20),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
    ),

    // Wave 2: Splitter + Summoner
    const SpawnEvent.enemy(time: 18, enemyType: EnemyType.splitter, x: 100),
    const SpawnEvent.enemy(time: 18, enemyType: EnemyType.summoner, x: 220),
    const SpawnEvent.enemy(time: 23, enemyType: EnemyType.stationary, x: 60),
    const SpawnEvent.enemy(time: 23, enemyType: EnemyType.stationary, x: 260),

    // Gate 2: Roulette
    const SpawnEvent.gate(
      time: 29,
      leftEffect: GateEffect(type: GateEffectType.roulette, value: 20, value2: -15),
      rightEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
    ),

    // Wave 3: Phalanx wall + Juggernaut
    const SpawnEvent.enemy(time: 35, enemyType: EnemyType.phalanx, x: 80),
    const SpawnEvent.enemy(time: 35, enemyType: EnemyType.phalanx, x: 160),
    const SpawnEvent.enemy(time: 35, enemyType: EnemyType.phalanx, x: 240),
    const SpawnEvent.enemy(time: 37, enemyType: EnemyType.juggernaut, x: 160),
    const SpawnEvent.enemy(time: 39, enemyType: EnemyType.dodger, x: 80),
    const SpawnEvent.enemy(time: 40, enemyType: EnemyType.carrier, x: 120),

    // Gate 3: Recovery
    const SpawnEvent.gate(
      time: 46,
      leftEffect: GateEffect(type: GateEffectType.hpRecover, value: 20),
      rightEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
    ),

    // Wave 4: Summoner + Splitter
    const SpawnEvent.enemy(time: 51, enemyType: EnemyType.summoner, x: 80),
    const SpawnEvent.enemy(time: 51, enemyType: EnemyType.splitter, x: 240),
    const SpawnEvent.enemy(time: 53, enemyType: EnemyType.dodger, x: 160),
    const SpawnEvent.enemy(time: 55, enemyType: EnemyType.swarm, x: 100),
    const SpawnEvent.enemy(time: 55, enemyType: EnemyType.swarm, x: 140),
    const SpawnEvent.enemy(time: 55, enemyType: EnemyType.swarm, x: 180),
    const SpawnEvent.enemy(time: 55, enemyType: EnemyType.swarm, x: 220),
    const SpawnEvent.enemy(time: 55, enemyType: EnemyType.swarm, x: 260),
    const SpawnEvent.enemy(time: 55, enemyType: EnemyType.swarm, x: 60),

    // Gate 4: Tradeoff + Growth
    const SpawnEvent.gate(
      time: 62,
      leftEffect: GateEffect(type: GateEffectType.tradeoffAtkUpSpdDown, value: 30, value2: 0.7),
      rightEffect: GateEffect(type: GateEffectType.growth, value: 8),
    ),

    // Wave 5: Double Juggernaut
    const SpawnEvent.enemy(time: 67, enemyType: EnemyType.juggernaut, x: 100),
    const SpawnEvent.enemy(time: 67, enemyType: EnemyType.juggernaut, x: 220),
    const SpawnEvent.enemy(time: 70, enemyType: EnemyType.dodger, x: 60),
    const SpawnEvent.enemy(time: 70, enemyType: EnemyType.dodger, x: 260),
    const SpawnEvent.enemy(time: 72, enemyType: EnemyType.patrol, x: 160),

    // Gate 5: Refit
    const SpawnEvent.gate(
      time: 77,
      leftEffect: GateEffect(type: GateEffectType.refit, value: 1), // → Heavy
      rightEffect: GateEffect(type: GateEffectType.refit, value: 2), // → Speed
    ),

    // Wave 6: Sentinel mini-boss + Summoner
    const SpawnEvent.enemy(time: 80, enemyType: EnemyType.sentinel, x: 200),
    const SpawnEvent.enemy(time: 83, enemyType: EnemyType.summoner, x: 160),
    const SpawnEvent.enemy(time: 83, enemyType: EnemyType.splitter, x: 80),
    const SpawnEvent.enemy(time: 85, enemyType: EnemyType.phalanx, x: 200),
    const SpawnEvent.enemy(time: 87, enemyType: EnemyType.swarm, x: 100),
    const SpawnEvent.enemy(time: 87, enemyType: EnemyType.swarm, x: 140),
    const SpawnEvent.enemy(time: 87, enemyType: EnemyType.swarm, x: 180),
    const SpawnEvent.enemy(time: 87, enemyType: EnemyType.swarm, x: 220),
    const SpawnEvent.enemy(time: 87, enemyType: EnemyType.swarm, x: 260),
    const SpawnEvent.enemy(time: 87, enemyType: EnemyType.swarm, x: 60),
    const SpawnEvent.enemy(time: 87, enemyType: EnemyType.swarm, x: 40),
    const SpawnEvent.enemy(time: 87, enemyType: EnemyType.swarm, x: 280),

    // Gate 6: Recovery
    const SpawnEvent.gate(
      time: 93,
      leftEffect: GateEffect(type: GateEffectType.hpRecover, value: 15),
      rightEffect: GateEffect(type: GateEffectType.atkAdd, value: 20),
    ),

    // Wave 7: Double Summoner + Splitter
    const SpawnEvent.enemy(time: 99, enemyType: EnemyType.summoner, x: 100),
    const SpawnEvent.enemy(time: 99, enemyType: EnemyType.summoner, x: 220),
    const SpawnEvent.enemy(time: 101, enemyType: EnemyType.splitter, x: 160),
    const SpawnEvent.enemy(time: 103, enemyType: EnemyType.dodger, x: 80),
    const SpawnEvent.enemy(time: 103, enemyType: EnemyType.dodger, x: 240),

    // Gate 7: Strong enhance
    const SpawnEvent.gate(
      time: 108,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 20),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
    ),

    // Wave 8: Final chaos
    const SpawnEvent.enemy(time: 113, enemyType: EnemyType.juggernaut, x: 160),
    const SpawnEvent.enemy(time: 113, enemyType: EnemyType.splitter, x: 80),
    const SpawnEvent.enemy(time: 113, enemyType: EnemyType.splitter, x: 240),
    const SpawnEvent.enemy(time: 115, enemyType: EnemyType.summoner, x: 160),
    const SpawnEvent.enemy(time: 117, enemyType: EnemyType.swarm, x: 100),
    const SpawnEvent.enemy(time: 117, enemyType: EnemyType.swarm, x: 140),
    const SpawnEvent.enemy(time: 117, enemyType: EnemyType.swarm, x: 180),
    const SpawnEvent.enemy(time: 117, enemyType: EnemyType.swarm, x: 220),
    const SpawnEvent.enemy(time: 117, enemyType: EnemyType.swarm, x: 260),
    const SpawnEvent.enemy(time: 117, enemyType: EnemyType.swarm, x: 60),
    const SpawnEvent.enemy(time: 119, enemyType: EnemyType.dodger, x: 200),

    // Gate 8: Final
    const SpawnEvent.gate(
      time: 124,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.2),
    ),
  ],
);
