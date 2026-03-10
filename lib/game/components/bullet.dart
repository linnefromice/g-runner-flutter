import 'dart:ui';

import 'package:flame/components.dart';

import '../data/constants.dart';
import '../g_runner_game.dart';

class PlayerBullet extends PositionComponent with HasGameReference<GRunnerGame> {
  final int damage;

  PlayerBullet({required this.damage, required Vector2 position})
      : super(
          position: position,
          size: Vector2(playerBulletWidth, playerBulletHeight),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= playerBulletSpeed * dt;

    // Remove when off screen
    if (position.y < -playerBulletHeight) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    // Glow
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), const Radius.circular(2)),
      Paint()
        ..color = const Color(0x4400FFAA)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Core
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), const Radius.circular(2)),
      Paint()..color = const Color(0xFF00FFAA),
    );
  }
}

class EnemyBullet extends PositionComponent with HasGameReference<GRunnerGame> {
  final int damage;
  final double speedX;
  final double speedY;

  EnemyBullet({
    required this.damage,
    required Vector2 position,
    this.speedX = 0,
    this.speedY = enemyBulletSpeed,
  }) : super(
          position: position,
          size: Vector2(enemyBulletWidth, enemyBulletHeight),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    position.x += speedX * dt;
    position.y += speedY * dt;

    // Remove when off screen
    if (position.y > game.logicalHeight + enemyBulletHeight ||
        position.y < -enemyBulletHeight ||
        position.x < -enemyBulletWidth ||
        position.x > logicalWidth + enemyBulletWidth) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    // Glow
    canvas.drawOval(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..color = const Color(0x44FF4444)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Core
    canvas.drawOval(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = const Color(0xFFFF4466),
    );
  }
}
