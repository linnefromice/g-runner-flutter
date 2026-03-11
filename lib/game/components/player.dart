import 'dart:ui';

import 'package:flame/components.dart';

import '../data/constants.dart';
import '../g_runner_game.dart';

class Player extends PositionComponent with HasGameReference<GRunnerGame> {
  int hp = playerInitialHp;
  int maxHp = playerInitialHp;
  int atk = playerInitialAtk;
  double speedMultiplier = 1.0;
  double defMultiplier = 1.0; // DEF upgrade: damage reduction

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

  // Awakening state (controlled by GRunnerGame)
  bool isAwakened = false;
  bool isAwakenedInvincible = false;
  double awakenedAtkMultiplier = 1.0;
  double awakenedSpeedMultiplier = 1.0;
  double awakenedFireRateMultiplier = 1.0;

  // Form system
  FormDefinition currentForm = formStandard;

  // Transform bonus
  double transformBonusTimer = 0;
  double transformBonusAtkMul = 1.0;
  double transformBonusSpeedMul = 1.0;
  double transformBonusFireRateMul = 1.0;

  Player()
      : super(
          size: Vector2(playerWidth, playerHeight),
          anchor: Anchor.center,
        );

  int get effectiveAtk =>
      (atk * currentForm.atkMultiplier * awakenedAtkMultiplier * transformBonusAtkMul).round();

  double get effectiveSpeed =>
      playerMoveSpeed *
      speedMultiplier *
      currentForm.speedMultiplier *
      awakenedSpeedMultiplier *
      transformBonusSpeedMul;

  double get effectiveFireInterval =>
      playerFireInterval /
      (currentForm.fireRateMultiplier * awakenedFireRateMultiplier * transformBonusFireRateMul);

  BulletType get activeBulletType =>
      isAwakened ? BulletType.normal : currentForm.bulletType;

  Color get activeBulletColor =>
      isAwakened ? const Color(0xFFFFEA00) : currentForm.bulletColor;

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

    // Transform bonus countdown
    if (transformBonusTimer > 0) {
      transformBonusTimer -= dt;
      if (transformBonusTimer <= 0) {
        transformBonusAtkMul = 1.0;
        transformBonusSpeedMul = 1.0;
        transformBonusFireRateMul = 1.0;
      }
    }

    // Tap-to-move: smooth slide toward target
    if (targetX != null && targetY != null) {
      final dx = targetX! - position.x;
      final dy = targetY! - position.y;
      final dist = (dx * dx + dy * dy);
      if (dist < 4) {
        targetX = null;
        targetY = null;
      } else {
        final d = dist > 0 ? _sqrt(dist) : 1;
        final speed = effectiveSpeed;
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
      fireTimer = effectiveFireInterval;
      game.spawnPlayerBullet(position.x, position.y - playerHeight / 2);
    }
  }

  void takeDamage(int damage) {
    if (isInvincible || isAwakenedInvincible) return;
    final reducedDamage = (damage * defMultiplier).round();
    hp -= reducedDamage;
    if (hp < 0) hp = 0;
    isInvincible = true;
    invincibleTimer = iframeDuration;
    _blinkTimer = iframeBlinkInterval;
    _blinkVisible = true;
  }

  void applyTransformBonus() {
    transformBonusTimer = transformBonusDuration;
    transformBonusAtkMul = transformBonusAtkMultiplier;
    transformBonusSpeedMul = transformBonusSpeedMultiplier;
    transformBonusFireRateMul = transformBonusFireRateMultiplier;
    hp = (hp + transformBonusHpHeal).clamp(0, maxHp);
  }

  @override
  void render(Canvas canvas) {
    if (!_blinkVisible) return;

    final w = size.x;
    final h = size.y;
    final cx = w / 2;

    // Awakening glow aura
    if (isAwakened) {
      final auraPath = Path()
        ..addOval(Rect.fromCenter(
          center: Offset(cx, h / 2),
          width: w * 1.4,
          height: h * 1.4,
        ));
      canvas.drawPath(
        auraPath,
        Paint()
          ..color = const Color(0x33FFEA00)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }

    // Transform bonus glow
    if (transformBonusTimer > 0 && !isAwakened) {
      final auraPath = Path()
        ..addOval(Rect.fromCenter(
          center: Offset(cx, h / 2),
          width: w * 1.2,
          height: h * 1.2,
        ));
      canvas.drawPath(
        auraPath,
        Paint()
          ..color = const Color(0x2244FFAA)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    // Ship body (triangle/arrow shape)
    final bodyPath = Path()
      ..moveTo(cx, 0) // nose
      ..lineTo(w, h * 0.8)
      ..lineTo(cx, h * 0.65)
      ..lineTo(0, h * 0.8)
      ..close();

    final Color bodyColor;
    if (isAwakened) {
      bodyColor = const Color(0xFFFFEA00); // Gold during awakening
    } else {
      bodyColor = currentForm.bulletColor; // Form color
    }

    // Glow
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = bodyColor.withValues(alpha: 0.33)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Body
    canvas.drawPath(
      bodyPath,
      Paint()..color = bodyColor,
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

  static double _sqrt(double value) {
    if (value <= 0) return 0;
    double x = value;
    double y = x / 2;
    for (int i = 0; i < 10; i++) {
      y = (y + x / y) / 2;
    }
    return y;
  }
}
