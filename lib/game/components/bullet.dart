import 'dart:ui';

import 'package:flame/components.dart';

import '../data/constants.dart';
import '../g_runner_game.dart';

class PlayerBullet extends PositionComponent with HasGameReference<GRunnerGame> {
  final int damage;
  final BulletType bulletType;
  final Color color;

  PlayerBullet({
    required this.damage,
    required Vector2 position,
    this.bulletType = BulletType.normal,
    this.color = const Color(0xFF00FFAA),
  }) : super(
          position: position,
          size: _sizeForType(bulletType),
          anchor: Anchor.center,
        );

  static Vector2 _sizeForType(BulletType type) {
    switch (type) {
      case BulletType.explosion:
        return Vector2(8, 8);
      case BulletType.pierce:
        return Vector2(3, 16);
      case BulletType.normal:
        return Vector2(playerBulletWidth, playerBulletHeight);
    }
  }

  /// Whether this bullet has already hit something (used for pierce tracking).
  /// Pierce bullets don't get removed on first hit.
  bool get isPierce => bulletType == BulletType.pierce;

  @override
  void update(double dt) {
    super.update(dt);

    final speed = bulletType == BulletType.pierce
        ? playerBulletSpeed * 1.25
        : bulletType == BulletType.explosion
            ? playerBulletSpeed * 0.75
            : playerBulletSpeed;

    position.y -= speed * dt;

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
        ..color = color.withValues(alpha: 0.27)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Core
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), const Radius.circular(2)),
      Paint()..color = color,
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
