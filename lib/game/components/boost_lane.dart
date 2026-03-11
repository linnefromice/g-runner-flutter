import 'dart:ui';

import 'package:flame/components.dart';

import '../g_runner_game.dart';

class BoostLane extends PositionComponent with HasGameReference<GRunnerGame> {
  BoostLane({
    required double laneX,
    required double laneWidth,
  }) : super(
          position: Vector2(laneX, 0),
          size: Vector2(laneWidth, 0), // height set in onLoad
          anchor: Anchor.topCenter,
        );

  double _pulseTimer = 0;

  @override
  void onLoad() {
    super.onLoad();
    size.y = game.logicalHeight;
  }

  bool containsPlayer() {
    final playerX = game.player.position.x;
    final left = position.x - size.x / 2;
    final right = position.x + size.x / 2;
    return playerX >= left && playerX <= right;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _pulseTimer += dt * 3;
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;
    final left = -w / 2;

    // Pulsing alpha
    final alpha = 0.08 + 0.04 * (1 + _pulseTimer.remainder(6.28).abs() < 3.14 ? 1.0 : -1.0);

    // Lane fill
    canvas.drawRect(
      Rect.fromLTWH(left, 0, w, h),
      Paint()..color = Color.fromRGBO(0, 255, 200, alpha),
    );

    // Lane borders
    final borderPaint = Paint()
      ..color = const Color(0x4400FFCC)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTWH(left, 0, w, h), borderPaint);

    // Chevrons
    final chevronPaint = Paint()
      ..color = const Color(0x3300FFCC)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    for (double y = (_pulseTimer * 30) % 60; y < h; y += 60) {
      canvas.drawLine(
        Offset(left + w * 0.3, y),
        Offset(left + w * 0.5, y - 10),
        chevronPaint,
      );
      canvas.drawLine(
        Offset(left + w * 0.5, y - 10),
        Offset(left + w * 0.7, y),
        chevronPaint,
      );
    }
  }
}
