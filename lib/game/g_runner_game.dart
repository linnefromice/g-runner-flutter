import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'components/background.dart';
import 'components/bullet.dart';
import 'components/enemy.dart';
import 'components/gate.dart';
import 'components/particle.dart';
import 'components/player.dart';
import 'data/constants.dart';
import 'data/stage_data.dart';

enum GameState { playing, gameOver, stageClear }

class GRunnerGame extends FlameGame {
  final StageData stageData;

  late Player player;
  late Background background;

  GameState state = GameState.playing;
  int score = 0;
  double stageTime = 0;
  int _spawnIndex = 0;

  // Callback for game end (navigates to result screen)
  void Function(GameState state, int score)? onGameEnd;

  double get logicalHeight => logicalWidth * (size.y / size.x);

  double get _scale => size.x / logicalWidth;

  GRunnerGame({required this.stageData});

  @override
  Future<void> onLoad() async {
    camera.viewfinder.visibleGameSize = Vector2(logicalWidth, logicalHeight);
    camera.viewfinder.anchor = Anchor.topLeft;

    background = Background();
    world.add(background);

    player = Player();
    player.position = Vector2(logicalWidth / 2, logicalHeight * 0.75);
    world.add(player);
  }

  @override
  void update(double dt) {
    if (state != GameState.playing) return;
    super.update(dt);

    stageTime += dt;

    _processSpawnEvents();
    _checkCollisions();
    _checkGateCollisions();

    if (player.hp <= 0) {
      state = GameState.gameOver;
      onGameEnd?.call(state, score);
    }

    if (stageTime >= stageData.duration) {
      final enemies = world.children.whereType<Enemy>();
      if (enemies.isEmpty) {
        state = GameState.stageClear;
        onGameEnd?.call(state, score);
      }
    }
  }

  void _processSpawnEvents() {
    final timeline = stageData.timeline;
    while (_spawnIndex < timeline.length &&
        timeline[_spawnIndex].time <= stageTime) {
      final event = timeline[_spawnIndex];
      switch (event.type) {
        case SpawnEventType.enemy:
          world.add(Enemy(
            type: event.enemyType!,
            position: Vector2(event.x!, -20),
          ));
        case SpawnEventType.gate:
          final leftX = gateWidth / 2;
          final rightX = logicalWidth - gateWidth / 2;
          world.add(Gate(
            effect: event.leftEffect!,
            isLeft: true,
            position: Vector2(leftX, -gateHeight),
          ));
          world.add(Gate(
            effect: event.rightEffect!,
            isLeft: false,
            position: Vector2(rightX, -gateHeight),
          ));
      }
      _spawnIndex++;
    }
  }

  void _checkCollisions() {
    final playerBullets = world.children.whereType<PlayerBullet>().toList();
    final enemies = world.children.whereType<Enemy>().toList();
    final enemyBullets = world.children.whereType<EnemyBullet>().toList();

    for (final bullet in playerBullets) {
      if (!bullet.isMounted) continue;
      final bulletRect = Rect.fromCenter(
        center: Offset(bullet.position.x, bullet.position.y),
        width: bullet.size.x,
        height: bullet.size.y,
      );
      for (final enemy in enemies) {
        if (!enemy.isMounted) continue;
        final enemyRect = Rect.fromCenter(
          center: Offset(enemy.position.x, enemy.position.y),
          width: enemy.size.x,
          height: enemy.size.y,
        );
        if (bulletRect.overlaps(enemyRect)) {
          enemy.takeDamage(bullet.damage);
          bullet.removeFromParent();
          break;
        }
      }
    }

    final playerHitbox = player.hitbox;
    for (final bullet in enemyBullets) {
      if (!bullet.isMounted) continue;
      final bulletRect = Rect.fromCenter(
        center: Offset(bullet.position.x, bullet.position.y),
        width: bullet.size.x,
        height: bullet.size.y,
      );
      if (bulletRect.overlaps(playerHitbox)) {
        player.takeDamage(bullet.damage);
        bullet.removeFromParent();
      }
    }
  }

  void _checkGateCollisions() {
    final gates = world.children.whereType<Gate>().toList();
    final playerRect = Rect.fromCenter(
      center: Offset(player.position.x, player.position.y),
      width: playerWidth,
      height: playerHeight,
    );

    for (final gate in gates) {
      if (gate.passed) continue;
      final gateRect = Rect.fromCenter(
        center: Offset(gate.position.x, gate.position.y),
        width: gate.size.x,
        height: gate.size.y,
      );
      if (playerRect.overlaps(gateRect)) {
        gate.passed = true;
        _applyGateEffect(gate.effect);
        score += gatePassScore;
      }
    }
  }

  void _applyGateEffect(GateEffect effect) {
    switch (effect.type) {
      case GateEffectType.atkAdd:
        player.atk += effect.value.toInt();
      case GateEffectType.speedMultiply:
        player.speedMultiplier *= effect.value;
    }
  }

  // --- Spawning helpers ---

  void spawnPlayerBullet(double x, double y) {
    world.add(PlayerBullet(
      damage: player.atk,
      position: Vector2(x, y),
    ));
  }

  void spawnEnemyBullet(double x, double y, int damage) {
    world.add(EnemyBullet(
      damage: damage,
      position: Vector2(x, y),
    ));
  }

  void onEnemyKilled(Enemy enemy) {
    score += enemyKillScore;
    spawnKillParticles(
      (p) => world.add(p),
      enemy.position.x,
      enemy.position.y,
      enemy.type == EnemyType.stationary
          ? const Color(0xFFFF6644)
          : const Color(0xFFFFAA22),
    );
  }

  // --- Input (called from Flutter widget layer) ---

  void handlePanUpdate(Offset globalPosition) {
    if (state != GameState.playing) return;
    final lx = globalPosition.dx / _scale;
    final ly = globalPosition.dy / _scale;
    player.position.x = lx;
    player.position.y = ly;
    player.targetX = null;
    player.targetY = null;
  }

  void handleTapUp(Offset globalPosition) {
    if (state != GameState.playing) return;
    player.targetX = globalPosition.dx / _scale;
    player.targetY = globalPosition.dy / _scale;
  }
}
