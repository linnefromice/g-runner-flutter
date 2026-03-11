import 'dart:ui';

import 'package:flame/components.dart';

import '../data/constants.dart';
import '../g_runner_game.dart';

class Debris extends PositionComponent with HasGameReference<GRunnerGame> {
  int hp;

  Debris({
    required Vector2 position,
  })  : hp = debrisHp,
        super(
          position: position,
          size: Vector2(debrisWidth, debrisHeight),
          anchor: Anchor.center,
        );

  void takeDamage(int damage) {
    hp -= damage;
    if (hp <= 0) {
      game.onDebrisDestroyed(this);
      removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += game.currentScrollSpeed * dt;

    if (position.y > game.logicalHeight + debrisHeight) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    // Glow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, w, h),
        const Radius.circular(4),
      ),
      Paint()
        ..color = const Color(0x448888AA)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, w, h),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF667788),
    );

    // Crack lines
    final crackPaint = Paint()
      ..color = const Color(0xFF334455)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.2, h * 0.3), Offset(w * 0.6, h * 0.5), crackPaint);
    canvas.drawLine(Offset(w * 0.5, h * 0.2), Offset(w * 0.8, h * 0.7), crackPaint);

    // HP indicator
    final hpRatio = (hp / debrisHp).clamp(0.0, 1.0);
    if (hpRatio < 1.0) {
      canvas.drawRect(
        Rect.fromLTWH(w * 0.1, h - 4, (w * 0.8) * hpRatio, 2),
        Paint()..color = const Color(0xFF88AACC),
      );
    }
  }
}
