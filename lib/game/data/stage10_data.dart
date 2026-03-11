import 'stage_data.dart';

/// Stage 10: Omega Core — Boss 2, 180秒
final stage10 = StageData(
  id: 10,
  name: 'Omega Core',
  duration: 180,
  hasBoss: true,
  creditReward: 150,
  timeline: [
    // Wave 1: Patrol opener
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.patrol, x: 80),
    const SpawnEvent.enemy(time: 2, enemyType: EnemyType.patrol, x: 240),
    const SpawnEvent.enemy(time: 5, enemyType: EnemyType.phalanx, x: 160),

    // Gate 1: Strong enhance
    const SpawnEvent.gate(
      time: 12,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 15),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
    ),

    // Wave 2: Heavy mix
    const SpawnEvent.enemy(time: 16, enemyType: EnemyType.juggernaut, x: 160),
    const SpawnEvent.enemy(time: 20, enemyType: EnemyType.sentinel, x: 80),
    const SpawnEvent.enemy(time: 20, enemyType: EnemyType.sentinel, x: 240),
    const SpawnEvent.enemy(time: 24, enemyType: EnemyType.swarm, x: 100),
    const SpawnEvent.enemy(time: 24, enemyType: EnemyType.swarm, x: 140),
    const SpawnEvent.enemy(time: 24, enemyType: EnemyType.swarm, x: 180),
    const SpawnEvent.enemy(time: 24, enemyType: EnemyType.swarm, x: 220),

    // Gate 2: Tradeoff
    const SpawnEvent.gate(
      time: 32,
      leftEffect: GateEffect(type: GateEffectType.tradeoffAtkUpSpdDown, value: 20, value2: 0.7),
      rightEffect: GateEffect(type: GateEffectType.hpRecover, value: 30),
    ),

    // Wave 3: Dodger + Rush gauntlet
    const SpawnEvent.enemy(time: 36, enemyType: EnemyType.dodger, x: 100),
    const SpawnEvent.enemy(time: 36, enemyType: EnemyType.dodger, x: 220),
    const SpawnEvent.enemy(time: 40, enemyType: EnemyType.rush, x: 80),
    const SpawnEvent.enemy(time: 40, enemyType: EnemyType.rush, x: 160),
    const SpawnEvent.enemy(time: 40, enemyType: EnemyType.rush, x: 240),
    const SpawnEvent.enemy(time: 44, enemyType: EnemyType.phalanx, x: 120),
    const SpawnEvent.enemy(time: 44, enemyType: EnemyType.phalanx, x: 200),

    // Gate 3: Refit
    const SpawnEvent.gate(
      time: 52,
      leftEffect: GateEffect(type: GateEffectType.refit, value: 1), // → Heavy
      rightEffect: GateEffect(type: GateEffectType.refit, value: 2), // → Speed
    ),

    // Wave 4: Pre-boss
    const SpawnEvent.enemy(time: 56, enemyType: EnemyType.juggernaut, x: 80),
    const SpawnEvent.enemy(time: 56, enemyType: EnemyType.juggernaut, x: 240),
    const SpawnEvent.enemy(time: 58, enemyType: EnemyType.splitter, x: 160),

    // Gate 4: Recovery before boss
    const SpawnEvent.gate(
      time: 62,
      leftEffect: GateEffect(type: GateEffectType.hpRecover, value: 20),
      rightEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
    ),

    // Boss 2 spawn
    const SpawnEvent.boss(time: 65, bossIndex: 2),
  ],
);
