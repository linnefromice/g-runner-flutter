import 'dart:ui';

import 'package:flame/components.dart';

import '../g_runner_game.dart';

class ScorePopup extends PositionComponent with HasGameReference<GRunnerGame> {
  final String text;
  final Color color;
  final double maxLife;
  double life;

  static const double _speed = 60; // upward speed

  ScorePopup({
    required this.text,
    required this.color,
    required Vector2 position,
    this.maxLife = 0.8,
  })  : life = maxLife,
        super(
          position: position,
          size: Vector2(60, 16),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= _speed * dt;
    life -= dt;
    if (life <= 0) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final lifeRatio = (life / maxLife).clamp(0.0, 1.0);
    final opacity = lifeRatio > 0.5 ? 1.0 : lifeRatio * 2;

    final paragraphBuilder = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 12,
    ))
      ..pushStyle(TextStyle(
        color: color.withValues(alpha: opacity),
        fontWeight: FontWeight.bold,
      ))
      ..addText(text);

    final paragraph = paragraphBuilder.build()
      ..layout(ParagraphConstraints(width: size.x));
    canvas.drawParagraph(paragraph, Offset(0, 0));
  }
}
