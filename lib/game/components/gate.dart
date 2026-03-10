import 'dart:ui';

import 'package:flame/components.dart';

import '../data/constants.dart';
import '../data/stage_data.dart';
import '../g_runner_game.dart';

class Gate extends PositionComponent with HasGameReference<GRunnerGame> {
  final GateEffect effect;
  final bool isLeft;
  bool passed = false;

  Gate({
    required this.effect,
    required this.isLeft,
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(gateWidth, gateHeight),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    position.y += baseScrollSpeed * dt;

    if (position.y > game.logicalHeight + gateHeight) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    final color = const Color(0xFF44FF88); // Enhance green

    // Border glow
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), const Radius.circular(4)),
      Paint()
        ..color = color.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Fill
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), const Radius.circular(4)),
      Paint()..color = color.withValues(alpha: passed ? 0.15 : 0.4),
    );

    // Border
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), const Radius.circular(4)),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Label
    final label = switch (effect.type) {
      GateEffectType.atkAdd => 'ATK +${effect.value.toInt()}',
      GateEffectType.speedMultiply => 'SPD x${effect.value}',
    };

    final paragraphBuilder = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 10,
    ))
      ..pushStyle(TextStyle(color: const Color(0xFFFFFFFF)))
      ..addText(label);

    final paragraph = paragraphBuilder.build()..layout(ParagraphConstraints(width: w));
    canvas.drawParagraph(paragraph, Offset(0, (h - paragraph.height) / 2));
  }
}
