import 'dart:ui';

import 'package:flame/components.dart';

import '../data/constants.dart';
import '../g_runner_game.dart';

class Player extends PositionComponent with HasGameReference<GRunnerGame> {
  int hp = playerInitialHp;
  int maxHp = playerInitialHp;
  int atk = playerInitialAtk;
  double speedMultiplier = 1.0;

  // Tap-to-move target
  double? targetX;
  double? targetY;

  // I-frame
  bool isInvincible = false;
  double invincibleTimer = 0;
  double _blinkTimer = 0;
  bool _blinkVisible = true;

  // Fire timer
  double fireTimer = 0;

  Player()
      : super(
          size: Vector2(playerWidth, playerHeight),
          anchor: Anchor.center,
        );

  Rect get hitbox {
    final cx = position.x;
    final cy = position.y;
    return Rect.fromCenter(
      center: Offset(cx, cy),
      width: playerHitboxSize,
      height: playerHitboxSize,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Tap-to-move: smooth slide toward target
    if (targetX != null && targetY != null) {
      final dx = targetX! - position.x;
      final dy = targetY! - position.y;
      final dist = (dx * dx + dy * dy);
      if (dist < 4) {
        // close enough
        targetX = null;
        targetY = null;
      } else {
        final d = dist > 0 ? dist.sqrt() : 1;
        final speed = playerMoveSpeed * speedMultiplier;
        final move = speed * dt;
        if (move >= d) {
          position.x = targetX!;
          position.y = targetY!;
          targetX = null;
          targetY = null;
        } else {
          position.x += (dx / d) * move;
          position.y += (dy / d) * move;
        }
      }
    }

    // Clamp to bounds
    position.x = position.x.clamp(playerWidth / 2, logicalWidth - playerWidth / 2);
    final minY = game.logicalHeight * 0.3;
    final maxY = game.logicalHeight - playerHeight;
    position.y = position.y.clamp(minY, maxY);

    // I-frame countdown
    if (isInvincible) {
      invincibleTimer -= dt;
      _blinkTimer -= dt;
      if (_blinkTimer <= 0) {
        _blinkVisible = !_blinkVisible;
        _blinkTimer = iframeBlinkInterval;
      }
      if (invincibleTimer <= 0) {
        isInvincible = false;
        _blinkVisible = true;
      }
    }

    // Auto-fire
    fireTimer -= dt;
    if (fireTimer <= 0) {
      fireTimer = playerFireInterval;
      game.spawnPlayerBullet(position.x, position.y - playerHeight / 2);
    }
  }

  void takeDamage(int damage) {
    if (isInvincible) return;
    hp -= damage;
    if (hp < 0) hp = 0;
    isInvincible = true;
    invincibleTimer = iframeDuration;
    _blinkTimer = iframeBlinkInterval;
    _blinkVisible = true;
  }

  @override
  void render(Canvas canvas) {
    if (!_blinkVisible) return;

    final w = size.x;
    final h = size.y;
    final cx = w / 2;

    // Ship body (triangle/arrow shape)
    final bodyPath = Path()
      ..moveTo(cx, 0) // nose
      ..lineTo(w, h * 0.8)
      ..lineTo(cx, h * 0.65)
      ..lineTo(0, h * 0.8)
      ..close();

    // Glow
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = const Color(0x3300CCFF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Body
    canvas.drawPath(
      bodyPath,
      Paint()..color = const Color(0xFF00CCFF),
    );

    // Cockpit accent
    final cockpitPath = Path()
      ..moveTo(cx, h * 0.15)
      ..lineTo(cx + 5, h * 0.45)
      ..lineTo(cx, h * 0.55)
      ..lineTo(cx - 5, h * 0.45)
      ..close();
    canvas.drawPath(
      cockpitPath,
      Paint()..color = const Color(0xFFFFFFFF),
    );
  }
}

extension on double {
  double sqrt() {
    if (this <= 0) return 0;
    // Use dart:math through a simple approach
    double x = this;
    double y = x / 2;
    for (int i = 0; i < 10; i++) {
      y = (y + x / y) / 2;
    }
    return y;
  }
}
