import 'dart:ui';

import 'package:flame/components.dart';

import '../data/constants.dart';
import '../g_runner_game.dart';

/// Full-screen upward beam from player position.
/// Damages enemies in beam width, destroys enemy bullets, lasts [exBurstDuration].
class ExBurst extends PositionComponent with HasGameReference<GRunnerGame> {
  double remainingTime = exBurstDuration;
  double _tickTimer = 0;

  ExBurst() : super(anchor: Anchor.bottomCenter);

  @override
  void update(double dt) {
    super.update(dt);

    // Follow player X position
    position.x = game.player.position.x;
    position.y = game.player.position.y;
    size = Vector2(exBurstWidth, game.player.position.y);

    remainingTime -= dt;
    if (remainingTime <= 0) {
      game.onExBurstEnd();
      removeFromParent();
      return;
    }

    // Damage tick
    _tickTimer += dt;
    if (_tickTimer >= exBurstTickInterval) {
      _tickTimer -= exBurstTickInterval;
      game.applyExBurstDamage(beamLeft, beamRight, position.y);
    }
  }

  double get beamLeft => position.x - exBurstWidth / 2;
  double get beamRight => position.x + exBurstWidth / 2;

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    // Fade out as time expires
    final alpha = (remainingTime / exBurstDuration).clamp(0.0, 1.0);

    // Outer glow
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..color = Color.fromARGB((40 * alpha).toInt(), 255, 234, 0)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    // Inner beam
    canvas.drawRect(
      Rect.fromLTWH(w * 0.15, 0, w * 0.7, h),
      Paint()
        ..color = Color.fromARGB((180 * alpha).toInt(), 255, 234, 0),
    );

    // Core beam
    canvas.drawRect(
      Rect.fromLTWH(w * 0.3, 0, w * 0.4, h),
      Paint()
        ..color = Color.fromARGB((255 * alpha).toInt(), 255, 255, 255),
    );
  }
}
