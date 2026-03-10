import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import '../data/constants.dart';
import '../data/stage_data.dart';
import '../g_runner_game.dart';

class Enemy extends PositionComponent with HasGameReference<GRunnerGame> {
  final EnemyType type;
  int hp;
  final int maxHp;
  final int atk;
  final double shootInterval;
  final double moveSpeed;

  double shootTimer;
  double _patrolDirection = 1;

  // Hit flash
  double _hitFlashTimer = 0;

  Enemy({
    required this.type,
    required Vector2 position,
  })  : hp = _statsFor(type).hp,
        maxHp = _statsFor(type).hp,
        atk = _statsFor(type).atk,
        shootInterval = _statsFor(type).shootInterval,
        moveSpeed = _statsFor(type).moveSpeed,
        shootTimer = _statsFor(type).shootInterval * 0.5, // stagger first shot
        super(
          position: position,
          size: Vector2(28, 28),
          anchor: Anchor.center,
        );

  static EnemyStats _statsFor(EnemyType type) {
    switch (type) {
      case EnemyType.stationary:
        return stationaryStats;
      case EnemyType.patrol:
        return patrolStats;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Scroll downward
    position.y += baseScrollSpeed * dt;

    // Patrol movement
    if (type == EnemyType.patrol) {
      position.x += moveSpeed * _patrolDirection * dt;
      if (position.x <= size.x / 2 || position.x >= logicalWidth - size.x / 2) {
        _patrolDirection *= -1;
        position.x = position.x.clamp(size.x / 2, logicalWidth - size.x / 2);
      }
    }

    // Shooting
    shootTimer -= dt;
    if (shootTimer <= 0) {
      shootTimer = shootInterval;
      if (type == EnemyType.patrol) {
        // Aimed shot toward player
        final dx = game.player.position.x - position.x;
        final dy = game.player.position.y - position.y;
        final dist = math.sqrt(dx * dx + dy * dy);
        if (dist > 0) {
          final vx = (dx / dist) * enemyBulletSpeed;
          final vy = (dy / dist) * enemyBulletSpeed;
          game.spawnEnemyBullet(position.x, position.y + size.y / 2, atk, speedX: vx, speedY: vy);
        }
      } else {
        game.spawnEnemyBullet(position.x, position.y + size.y / 2, atk);
      }
    }

    // Hit flash decay
    if (_hitFlashTimer > 0) {
      _hitFlashTimer -= dt;
    }

    // Remove when off screen
    if (position.y > game.logicalHeight + 50) {
      removeFromParent();
    }
  }

  void takeDamage(int damage) {
    hp -= damage;
    _hitFlashTimer = 0.1;
    if (hp <= 0) {
      game.onEnemyKilled(this);
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;
    final cx = w / 2;

    final bool isFlashing = _hitFlashTimer > 0;

    // 2.5D depth scaling: closer to top = smaller
    final depthScale = _depthScale();

    canvas.save();
    canvas.translate(cx, h / 2);
    canvas.scale(depthScale, depthScale);
    canvas.translate(-cx, -h / 2);

    final Color bodyColor;
    if (isFlashing) {
      bodyColor = const Color(0xFFFFFFFF);
    } else {
      switch (type) {
        case EnemyType.stationary:
          bodyColor = const Color(0xFFFF6644);
        case EnemyType.patrol:
          bodyColor = const Color(0xFFFFAA22);
      }
    }

    // Enemy body (inverted triangle)
    final bodyPath = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(cx, h)
      ..close();

    // Glow
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = bodyColor.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    canvas.drawPath(bodyPath, Paint()..color = bodyColor);

    // HP bar
    if (hp < maxHp) {
      final hpRatio = hp / maxHp;
      final barWidth = w;
      final barHeight = 3.0;
      final barY = -6.0;

      canvas.drawRect(
        Rect.fromLTWH(0, barY, barWidth, barHeight),
        Paint()..color = const Color(0x88000000),
      );
      canvas.drawRect(
        Rect.fromLTWH(0, barY, barWidth * hpRatio, barHeight),
        Paint()..color = const Color(0xFF44FF44),
      );
    }

    canvas.restore();
  }

  double _depthScale() {
    // Y position mapped to 0.75–1.0 scale
    final normalizedY = (position.y / game.logicalHeight).clamp(0.0, 1.0);
    return 0.75 + normalizedY * 0.25;
  }
}
