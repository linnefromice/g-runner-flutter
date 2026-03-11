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
    position.y += game.currentScrollSpeed * dt;

    if (position.y > game.logicalHeight + gateHeight) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    final Color color;
    if (effect.type.isTradeoff) {
      color = const Color(0xFFFFDD44); // Tradeoff yellow
    } else if (effect.type == GateEffectType.hpRecover) {
      color = const Color(0xFFFF69B4); // Recovery pink
    } else if (effect.type == GateEffectType.refit) {
      color = const Color(0xFFAA44FF); // Refit purple
    } else if (effect.type == GateEffectType.growth) {
      color = const Color(0xFF44DD88); // Growth green
    } else if (effect.type == GateEffectType.roulette) {
      color = const Color(0xFFFF44AA); // Roulette magenta
    } else {
      color = const Color(0xFF44FF88); // Enhance green
    }

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
    final label = _labelForEffect(effect);

    final paragraphBuilder = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 10,
    ))
      ..pushStyle(TextStyle(color: const Color(0xFFFFFFFF)))
      ..addText(label);

    final paragraph = paragraphBuilder.build()..layout(ParagraphConstraints(width: w));
    canvas.drawParagraph(paragraph, Offset(0, (h - paragraph.height) / 2));
  }

  static String _labelForEffect(GateEffect effect) {
    switch (effect.type) {
      case GateEffectType.atkAdd:
        return 'ATK +${effect.value.toInt()}';
      case GateEffectType.speedMultiply:
        return 'SPD x${effect.value}';
      case GateEffectType.hpRecover:
        return 'HP +${effect.value.toInt()}';
      case GateEffectType.tradeoffAtkUpSpdDown:
        return 'ATK+${effect.value.toInt()} SPD${effect.value2}';
      case GateEffectType.tradeoffSpdUpAtkDown:
        return 'SPD x${effect.value} ATK${effect.value2}';
      case GateEffectType.refit:
        final formNames = ['Std', 'Heavy', 'Speed', 'Sniper', 'Scatter', 'Guard'];
        final idx = effect.value.toInt().clamp(0, formNames.length - 1);
        return '→ ${formNames[idx]}';
      case GateEffectType.growth:
        return 'ATK +${effect.value.toInt()}';
      case GateEffectType.roulette:
        return '? ATK';
    }
  }
}
