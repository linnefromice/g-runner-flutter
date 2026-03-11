import 'stage_data.dart';

/// Stage 9: Final Approach — 全敵種 + Carrier, 130秒
final stage9 = StageData(
  id: 9,
  name: 'Final Approach',
  duration: 130,
  timeline: [
    // Wave 1: Patrol + Stationary
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.patrol, x: 80),
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.patrol, x: 240),
    const SpawnEvent.enemy(time: 4, enemyType: EnemyType.stationary, x: 160),

    // Gate 1: Strong enhance
    const SpawnEvent.gate(
      time: 10,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 15),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
    ),

    // Wave 2: Swarm + Phalanx
    const SpawnEvent.enemy(time: 14, enemyType: EnemyType.swarm, x: 60),
    const SpawnEvent.enemy(time: 14, enemyType: EnemyType.swarm, x: 100),
    const SpawnEvent.enemy(time: 14, enemyType: EnemyType.swarm, x: 220),
    const SpawnEvent.enemy(time: 14, enemyType: EnemyType.swarm, x: 260),
    const SpawnEvent.enemy(time: 18, enemyType: EnemyType.phalanx, x: 160),

    // Wave 3: Dodger + Rush
    const SpawnEvent.enemy(time: 24, enemyType: EnemyType.dodger, x: 100),
    const SpawnEvent.enemy(time: 24, enemyType: EnemyType.dodger, x: 220),
    const SpawnEvent.enemy(time: 28, enemyType: EnemyType.rush, x: 160),
    const SpawnEvent.enemy(time: 30, enemyType: EnemyType.rush, x: 80),
    const SpawnEvent.enemy(time: 30, enemyType: EnemyType.rush, x: 240),

    // Gate 2: Tradeoff extreme
    const SpawnEvent.gate(
      time: 36,
      leftEffect: GateEffect(type: GateEffectType.tradeoffAtkUpSpdDown, value: 20, value2: 0.7),
      rightEffect: GateEffect(type: GateEffectType.tradeoffSpdUpAtkDown, value: 1.5, value2: 0.6),
    ),

    // Wave 4: Splitter + Summoner
    const SpawnEvent.enemy(time: 40, enemyType: EnemyType.splitter, x: 100),
    const SpawnEvent.enemy(time: 40, enemyType: EnemyType.splitter, x: 220),
    const SpawnEvent.enemy(time: 45, enemyType: EnemyType.carrier, x: 160),

    // Gate 3: Refit
    const SpawnEvent.gate(
      time: 54,
      leftEffect: GateEffect(type: GateEffectType.refit, value: 1), // → Heavy
      rightEffect: GateEffect(type: GateEffectType.refit, value: 2), // → Speed
    ),

    // Wave 5: Juggernaut + Sentinel fortress
    const SpawnEvent.enemy(time: 58, enemyType: EnemyType.sentinel, x: 160),
    const SpawnEvent.enemy(time: 60, enemyType: EnemyType.juggernaut, x: 80),
    const SpawnEvent.enemy(time: 60, enemyType: EnemyType.juggernaut, x: 240),
    const SpawnEvent.enemy(time: 64, enemyType: EnemyType.phalanx, x: 120),
    const SpawnEvent.enemy(time: 64, enemyType: EnemyType.phalanx, x: 200),

    // Gate 4: Extreme tradeoff
    const SpawnEvent.gate(
      time: 72,
      leftEffect: GateEffect(type: GateEffectType.tradeoffAtkUpSpdDown, value: 15, value2: 0.8),
      rightEffect: GateEffect(type: GateEffectType.tradeoffSpdUpAtkDown, value: 1.3, value2: 0.7),
    ),

    // Wave 6: All mixed
    const SpawnEvent.enemy(time: 78, enemyType: EnemyType.dodger, x: 80),
    const SpawnEvent.enemy(time: 78, enemyType: EnemyType.summoner, x: 240),
    const SpawnEvent.enemy(time: 82, enemyType: EnemyType.rush, x: 120),
    const SpawnEvent.enemy(time: 82, enemyType: EnemyType.rush, x: 200),
    const SpawnEvent.enemy(time: 86, enemyType: EnemyType.phalanx, x: 160),
    const SpawnEvent.enemy(time: 88, enemyType: EnemyType.splitter, x: 80),
    const SpawnEvent.enemy(time: 88, enemyType: EnemyType.splitter, x: 240),

    // Gate 5: Recovery
    const SpawnEvent.gate(
      time: 96,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
      rightEffect: GateEffect(type: GateEffectType.hpRecover, value: 15),
    ),

    // Wave 7: Final massive wave
    const SpawnEvent.enemy(time: 100, enemyType: EnemyType.juggernaut, x: 160),
    const SpawnEvent.enemy(time: 102, enemyType: EnemyType.sentinel, x: 80),
    const SpawnEvent.enemy(time: 102, enemyType: EnemyType.sentinel, x: 240),
    const SpawnEvent.enemy(time: 106, enemyType: EnemyType.swarm, x: 100),
    const SpawnEvent.enemy(time: 106, enemyType: EnemyType.swarm, x: 140),
    const SpawnEvent.enemy(time: 106, enemyType: EnemyType.swarm, x: 180),
    const SpawnEvent.enemy(time: 106, enemyType: EnemyType.swarm, x: 220),
    const SpawnEvent.enemy(time: 110, enemyType: EnemyType.dodger, x: 120),
    const SpawnEvent.enemy(time: 110, enemyType: EnemyType.dodger, x: 200),

    // Gate 6: Final
    const SpawnEvent.gate(
      time: 120,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 15),
      rightEffect: GateEffect(type: GateEffectType.hpRecover, value: 15),
    ),
  ],
);
