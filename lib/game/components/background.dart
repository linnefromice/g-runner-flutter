import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../data/constants.dart';
import '../g_runner_game.dart';

/// Parallax star-field background with grid scanlines
class Background extends Component with HasGameReference<GRunnerGame> {
  final List<_Star> _stars = [];
  final Random _rng = Random(42);

  double get _logicalHeight => game.logicalHeight;

  @override
  Future<void> onLoad() async {
    _generateStars();
  }

  void _generateStars() {
    _stars.clear();
    // 3 layers: far (slow), mid, near (fast)
    for (int layer = 0; layer < 3; layer++) {
      final count = 20 + layer * 10;
      final speed = 20.0 + layer * 30.0; // 20, 50, 80
      final size = 1.0 + layer * 0.5;
      final opacity = 0.3 + layer * 0.2;
      for (int i = 0; i < count; i++) {
        _stars.add(_Star(
          x: _rng.nextDouble() * logicalWidth,
          y: _rng.nextDouble() * _logicalHeight,
          speed: speed,
          size: size,
          opacity: opacity,
        ));
      }
    }
  }

  @override
  void update(double dt) {
    for (final star in _stars) {
      star.y += star.speed * dt;
      if (star.y > _logicalHeight) {
        star.y -= _logicalHeight;
        star.x = _rng.nextDouble() * logicalWidth;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Black background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, logicalWidth, _logicalHeight),
      Paint()..color = const Color(0xFF0A0A1A),
    );

    // Stars
    for (final star in _stars) {
      canvas.drawCircle(
        Offset(star.x, star.y),
        star.size,
        Paint()..color = Color.fromRGBO(200, 220, 255, star.opacity),
      );
    }

    // Grid scanlines (subtle)
    final linePaint = Paint()
      ..color = const Color(0x0D4488FF)
      ..strokeWidth = 0.5;
    for (double y = 0; y < _logicalHeight; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(logicalWidth, y), linePaint);
    }
  }
}

class _Star {
  double x;
  double y;
  final double speed;
  final double size;
  final double opacity;

  _Star({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
  });
}
