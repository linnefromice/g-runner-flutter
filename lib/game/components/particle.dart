import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

/// Simple particle burst effect on enemy kill
class KillParticle extends PositionComponent {
  final Color color;
  final double vx;
  final double vy;
  double life;
  final double maxLife;

  KillParticle({
    required Vector2 position,
    required this.color,
    required this.vx,
    required this.vy,
    this.maxLife = 0.4,
  })  : life = maxLife,
        super(position: position, size: Vector2(3, 3), anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    position.x += vx * dt;
    position.y += vy * dt;
    life -= dt;
    if (life <= 0) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final opacity = (life / maxLife).clamp(0.0, 1.0);
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      Paint()..color = color.withValues(alpha: opacity),
    );
  }
}

void spawnKillParticles(
  void Function(KillParticle) adder,
  double x,
  double y,
  Color baseColor,
) {
  final rng = Random();
  for (int i = 0; i < 8; i++) {
    final angle = (i / 8) * 2 * pi + rng.nextDouble() * 0.3;
    final speed = 80 + rng.nextDouble() * 60;
    adder(KillParticle(
      position: Vector2(x, y),
      color: baseColor,
      vx: cos(angle) * speed,
      vy: sin(angle) * speed,
    ));
  }
}
