// Endless mode wave generation and difficulty scaling

import 'dart:math';

import 'constants.dart';
import 'stage_data.dart';

// All enemy types available for endless mode, ordered by unlock progression
const List<EnemyType> _enemyPool = [
  EnemyType.stationary,
  EnemyType.patrol,
  EnemyType.rush,
  EnemyType.swarm,
  EnemyType.phalanx,
  EnemyType.juggernaut,
  EnemyType.dodger,
  EnemyType.splitter,
  EnemyType.summoner,
  EnemyType.sentinel,
  EnemyType.carrier,
];

// Gate pairs organized by difficulty tier
const List<List<GateEffect>> _earlyGates = [
  [
    GateEffect(type: GateEffectType.atkAdd, value: 5),
    GateEffect(type: GateEffectType.speedMultiply, value: 1.2),
  ],
  [
    GateEffect(type: GateEffectType.hpRecover, value: 20),
    GateEffect(type: GateEffectType.atkAdd, value: 8),
  ],
];

const List<List<GateEffect>> _midGates = [
  [
    GateEffect(type: GateEffectType.growth, value: 3),
    GateEffect(type: GateEffectType.hpRecover, value: 30),
  ],
  [
    GateEffect(type: GateEffectType.atkAdd, value: 10),
    GateEffect(type: GateEffectType.speedMultiply, value: 1.3),
  ],
];

const List<List<GateEffect>> _lateGates = [
  [
    GateEffect(type: GateEffectType.growth, value: 5),
    GateEffect(type: GateEffectType.hpRecover, value: 40),
  ],
  [
    GateEffect(
      type: GateEffectType.tradeoffAtkUpSpdDown,
      value: 15,
      value2: 0.8,
    ),
    GateEffect(
      type: GateEffectType.tradeoffSpdUpAtkDown,
      value: 1.4,
      value2: -5,
    ),
  ],
];

class EndlessDifficulty {
  final double scrollSpeedMultiplier;
  final double enemyHpMultiplier;
  final double enemyAtkMultiplier;
  final int maxConcurrentEnemies;

  const EndlessDifficulty({
    required this.scrollSpeedMultiplier,
    required this.enemyHpMultiplier,
    required this.enemyAtkMultiplier,
    required this.maxConcurrentEnemies,
  });
}

EndlessDifficulty getEndlessDifficulty(double elapsedTime) {
  final minutes = elapsedTime / 60.0;
  return EndlessDifficulty(
    scrollSpeedMultiplier: 1.0 + endlessScrollSpeedPerMinute * minutes,
    enemyHpMultiplier: 1.0 + endlessHpPerMinute * minutes,
    enemyAtkMultiplier: 1.0 + endlessAtkPerMinute * minutes,
    maxConcurrentEnemies:
        (endlessBaseMaxConcurrent + endlessMaxConcurrentPerMinute * minutes)
            .toInt()
            .clamp(endlessBaseMaxConcurrent, 20),
  );
}

List<SpawnEvent> generateEndlessWave(int waveNumber, Random rng) {
  final events = <SpawnEvent>[];
  final waveStart = waveNumber * endlessWaveDuration;

  // How many enemy types are available (unlocks progressively)
  final availableTypes =
      (endlessBaseEnemyCount + waveNumber).clamp(3, endlessMaxEnemyTypes);

  // Number of enemies per wave (scales with wave number)
  final enemyCount = (3 + waveNumber ~/ 2).clamp(3, 8);

  // Spread enemies across the wave duration
  for (int i = 0; i < enemyCount; i++) {
    final spawnTime = waveStart + (i + 1) * (endlessWaveDuration / (enemyCount + 1));
    final enemyIndex = rng.nextInt(availableTypes);
    final x = 40.0 + rng.nextDouble() * (logicalWidth - 80);
    events.add(SpawnEvent.enemy(
      time: spawnTime,
      enemyType: _enemyPool[enemyIndex],
      x: x,
    ));
  }

  // Add gates every 2 waves at the 15-second mark
  if (waveNumber > 0 && waveNumber % 2 == 1) {
    final gateTime = waveStart + 15;
    List<List<GateEffect>> pool;
    if (waveNumber < 4) {
      pool = _earlyGates;
    } else if (waveNumber < 8) {
      pool = [..._earlyGates, ..._midGates];
    } else {
      pool = [..._earlyGates, ..._midGates, ..._lateGates];
    }
    final pair = pool[rng.nextInt(pool.length)];
    events.add(SpawnEvent.gate(
      time: gateTime,
      leftEffect: pair[0],
      rightEffect: pair[1],
    ));
  }

  return events;
}
