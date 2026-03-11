import 'stage_data.dart';

/// Stage 15: Terminus Core — Boss 3, 180秒
final stage15 = StageData(
  id: 15,
  name: 'Terminus Core',
  duration: 180,
  hasBoss: true,
  creditReward: 150,
  timeline: [
    // Wave 1: Quick gauntlet opener
    const SpawnEvent.enemy(time: 3, enemyType: EnemyType.patrol, x: 100),
    const SpawnEvent.enemy(time: 5, enemyType: EnemyType.dodger, x: 220),
    const SpawnEvent.enemy(time: 8, enemyType: EnemyType.swarm, x: 120),
    const SpawnEvent.enemy(time: 8, enemyType: EnemyType.swarm, x: 160),
    const SpawnEvent.enemy(time: 8, enemyType: EnemyType.swarm, x: 200),
    const SpawnEvent.enemy(time: 8, enemyType: EnemyType.swarm, x: 240),
    const SpawnEvent.enemy(time: 8, enemyType: EnemyType.swarm, x: 80),

    // Gate 1: Act 3 enhance
    const SpawnEvent.gate(
      time: 14,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 20),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
    ),

    // Wave 2: Heavy gauntlet
    const SpawnEvent.enemy(time: 20, enemyType: EnemyType.phalanx, x: 120),
    const SpawnEvent.enemy(time: 22, enemyType: EnemyType.summoner, x: 200),
    const SpawnEvent.enemy(time: 24, enemyType: EnemyType.splitter, x: 80),

    // Gate 2: Strong enhance
    const SpawnEvent.gate(
      time: 30,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 20),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
    ),

    // Wave 3: Juggernaut + Dodger
    const SpawnEvent.enemy(time: 36, enemyType: EnemyType.juggernaut, x: 160),
    const SpawnEvent.enemy(time: 38, enemyType: EnemyType.dodger, x: 80),
    const SpawnEvent.enemy(time: 38, enemyType: EnemyType.dodger, x: 240),

    // Gate 3: Tradeoff
    const SpawnEvent.gate(
      time: 46,
      leftEffect: GateEffect(type: GateEffectType.tradeoffAtkUpSpdDown, value: 25, value2: 0.7),
      rightEffect: GateEffect(type: GateEffectType.tradeoffSpdUpAtkDown, value: 1.5, value2: 0.6),
    ),

    // Gate 4: Refit
    const SpawnEvent.gate(
      time: 50,
      leftEffect: GateEffect(type: GateEffectType.refit, value: 1), // → Heavy
      rightEffect: GateEffect(type: GateEffectType.refit, value: 2), // → Speed
    ),

    // Gate 5: Recovery before boss
    const SpawnEvent.gate(
      time: 54,
      leftEffect: GateEffect(type: GateEffectType.hpRecover, value: 20),
      rightEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
    ),

    // Gate 6: Final prep
    const SpawnEvent.gate(
      time: 58,
      leftEffect: GateEffect(type: GateEffectType.atkAdd, value: 10),
      rightEffect: GateEffect(type: GateEffectType.speedMultiply, value: 1.2),
    ),

    // Boss 3 spawn
    const SpawnEvent.boss(time: 65, bossIndex: 3),
  ],
);
