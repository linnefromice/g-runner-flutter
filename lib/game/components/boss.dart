import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import '../data/constants.dart';
import '../data/difficulty.dart';
import '../g_runner_game.dart';
import 'particle.dart';

enum BossPhase { entering, phase1, phase2, phase3 }

enum LaserState { idle, warning, firing, cooldown }

class Boss extends PositionComponent with HasGameReference<GRunnerGame> {
  final int bossIndex;
  late final int maxHp;
  late int hp;
  BossPhase phase = BossPhase.entering;

  double _shootTimer = bossShootInterval1;
  double _hoverTimer = 0;
  double _hitFlashTimer = 0;
  bool _dronesSpawned = false;

  // Laser attack
  LaserState laserState = LaserState.idle;
  double _laserTimer = 0;
  double _laserTickTimer = 0;
  double laserX = 0; // X position of laser center (world coords)

  Boss({this.bossIndex = 1})
      : super(
          size: Vector2(bossWidth, bossHeight),
          anchor: Anchor.center,
          position: Vector2(logicalWidth / 2, -bossHeight),
        ) {
    maxHp = getBossHp(bossIndex);
    hp = maxHp;
  }

  int get _droneCount => bossDroneCount + (bossIndex - 1);

  double get _phase2Threshold => bossIndex >= 2 ? 0.75 : bossPhase2Threshold;
  double get _phase3Threshold => bossIndex >= 2 ? 0.50 : bossPhase3Threshold;

  double get hpRatio => hp / maxHp;

  double get _currentShootInterval {
    switch (phase) {
      case BossPhase.entering:
        return double.infinity;
      case BossPhase.phase1:
        return bossShootInterval1;
      case BossPhase.phase2:
        return bossShootInterval2;
      case BossPhase.phase3:
        return bossShootInterval3;
    }
  }

  double get _currentBulletSpeed {
    switch (phase) {
      case BossPhase.phase2:
      case BossPhase.phase3:
        return bossBulletSpeed * 1.3;
      default:
        return bossBulletSpeed;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    _hoverTimer += dt;

    if (_hitFlashTimer > 0) {
      _hitFlashTimer -= dt;
    }

    switch (phase) {
      case BossPhase.entering:
        _updateEntering(dt);
      default:
        _updateCombat(dt);
    }

    _updatePhaseTransition();
  }

  void _updateEntering(double dt) {
    position.y += bossSlideSpeed * dt;
    if (position.y >= bossHoverY) {
      position.y = bossHoverY;
      phase = BossPhase.phase1;
      game.onBossPhaseStarted();
    }
  }

  bool get _laserEnabled => phase == BossPhase.phase2 || phase == BossPhase.phase3;

  void _updateCombat(double dt) {
    // Hover movement (sine wave)
    position.x = logicalWidth / 2 +
        math.sin(_hoverTimer * 2 * math.pi / bossHoverPeriod) * bossHoverAmplitude;

    // Laser state machine (Phase 2+)
    if (_laserEnabled) {
      _updateLaser(dt);
    }

    // Spread shooting (only when laser is idle or cooldown)
    if (laserState == LaserState.idle || laserState == LaserState.cooldown) {
      _shootTimer -= dt;
      if (_shootTimer <= 0) {
        _shootTimer = _currentShootInterval;
        _fireSpreadShot();
      }
    }
  }

  void _updateLaser(double dt) {
    _laserTimer -= dt;
    switch (laserState) {
      case LaserState.idle:
        // Start warning phase
        laserState = LaserState.warning;
        _laserTimer = bossLaserWarningDuration;
        laserX = position.x; // Lock laser X at boss center
      case LaserState.warning:
        if (_laserTimer <= 0) {
          laserState = LaserState.firing;
          _laserTimer = bossLaserFireDuration;
          _laserTickTimer = 0;
        }
      case LaserState.firing:
        _laserTickTimer -= dt;
        if (_laserTickTimer <= 0) {
          _laserTickTimer = bossLaserTickInterval;
          _applyLaserDamage();
        }
        if (_laserTimer <= 0) {
          laserState = LaserState.cooldown;
          _laserTimer = bossLaserCooldown;
        }
      case LaserState.cooldown:
        if (_laserTimer <= 0) {
          laserState = LaserState.idle;
        }
    }
  }

  void _applyLaserDamage() {
    final player = game.player;
    if (player.isInvincible || player.isAwakenedInvincible) return;

    final halfWidth = bossLaserWidth / 2;
    if ((player.position.x - laserX).abs() <= halfWidth) {
      player.takeDamage(bossLaserDamage);
      game.resetCombo();
      game.triggerShake(shakePlayerHitIntensity, shakePlayerHitDuration);
    }
  }

  void _updatePhaseTransition() {
    if (phase == BossPhase.entering) return;

    if (hpRatio <= _phase3Threshold && phase != BossPhase.phase3) {
      phase = BossPhase.phase3;
      if (!_dronesSpawned) {
        _spawnDrones();
        _dronesSpawned = true;
      }
    } else if (hpRatio <= _phase2Threshold && phase == BossPhase.phase1) {
      phase = BossPhase.phase2;
    }
  }

  void _fireSpreadShot() {
    final centerAngle = math.pi / 2; // downward
    final totalSpread = (bossSpreadCount - 1) * bossSpreadAngle * math.pi / 180;
    final startAngle = centerAngle - totalSpread / 2;

    for (int i = 0; i < bossSpreadCount; i++) {
      final angle = startAngle + i * bossSpreadAngle * math.pi / 180;
      final vx = math.cos(angle) * _currentBulletSpeed;
      final vy = math.sin(angle) * _currentBulletSpeed;
      game.spawnEnemyBullet(
        position.x,
        position.y + size.y / 2,
        bossAtk,
        speedX: vx,
        speedY: vy,
      );
    }
  }

  void _spawnDrones() {
    final count = _droneCount;
    final spacing = size.x / (count + 1);
    for (int i = 0; i < count; i++) {
      final droneX = position.x - size.x / 2 + spacing * (i + 1);
      final drone = BossDrone(
        position: Vector2(droneX, position.y + size.y / 2 + 20),
      );
      game.world.add(drone);
    }
  }

  void takeDamage(int damage) {
    hp -= damage;
    _hitFlashTimer = 0.1;

    // EX gauge on boss hit
    game.addExGauge(exGainOnBossHit);

    if (hp <= 0) {
      hp = 0;
      game.onBossDefeated(this);
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;
    final cx = w / 2;

    final bool isFlashing = _hitFlashTimer > 0;

    // Boss body color based on phase
    final Color bodyColor;
    if (isFlashing) {
      bodyColor = const Color(0xFFFFFFFF);
    } else {
      switch (phase) {
        case BossPhase.entering:
        case BossPhase.phase1:
          bodyColor = const Color(0xFF8844FF); // Purple
        case BossPhase.phase2:
          bodyColor = const Color(0xFFFF6644); // Orange-red
        case BossPhase.phase3:
          bodyColor = const Color(0xFFFF2244); // Red
      }
    }

    // Large hexagonal boss shape
    final bodyPath = Path()
      ..moveTo(cx * 0.4, 0)
      ..lineTo(w - cx * 0.4, 0)
      ..lineTo(w, h * 0.35)
      ..lineTo(w - cx * 0.2, h * 0.7)
      ..lineTo(cx + 20, h)
      ..lineTo(cx - 20, h)
      ..lineTo(cx * 0.2, h * 0.7)
      ..lineTo(0, h * 0.35)
      ..close();

    // Glow
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = bodyColor.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Body
    canvas.drawPath(bodyPath, Paint()..color = bodyColor);

    // Core detail
    final corePath = Path()
      ..moveTo(cx - 20, h * 0.2)
      ..lineTo(cx + 20, h * 0.2)
      ..lineTo(cx + 15, h * 0.5)
      ..lineTo(cx, h * 0.6)
      ..lineTo(cx - 15, h * 0.5)
      ..close();
    canvas.drawPath(
      corePath,
      Paint()..color = const Color(0xFFFFFFFF).withValues(alpha: 0.5),
    );

    // Laser beam (rendered in boss-local coordinates)
    if (laserState == LaserState.warning || laserState == LaserState.firing) {
      _renderLaser(canvas, w, h, cx);
    }
  }

  void _renderLaser(Canvas canvas, double w, double h, double cx) {
    // Laser X is in world coords; convert to boss-local
    final localLaserX = laserX - (position.x - w / 2);
    final halfWidth = bossLaserWidth / 2;
    final beamHeight = game.logicalHeight; // extend to bottom of screen

    if (laserState == LaserState.warning) {
      // Pulsing warning line
      final pulse = (math.sin(_hoverTimer * bossLaserPulseSpeed) + 1) / 2;
      final alpha = 0.2 + pulse * 0.4;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(localLaserX, h + beamHeight / 2),
          width: halfWidth * 2 * (0.3 + pulse * 0.3),
          height: beamHeight,
        ),
        Paint()..color = Color.fromRGBO(255, 50, 50, alpha),
      );
    } else if (laserState == LaserState.firing) {
      // Bright beam
      // Glow
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(localLaserX, h + beamHeight / 2),
          width: halfWidth * 3,
          height: beamHeight,
        ),
        Paint()
          ..color = const Color(0x44FF2222)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
      // Core beam
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(localLaserX, h + beamHeight / 2),
          width: halfWidth * 2,
          height: beamHeight,
        ),
        Paint()..color = const Color(0xCCFF4444),
      );
      // Bright center
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(localLaserX, h + beamHeight / 2),
          width: halfWidth * 0.6,
          height: beamHeight,
        ),
        Paint()..color = const Color(0xEEFFAAAA),
      );
    }
  }
}

/// Small drone enemy spawned by boss in Phase 3
class BossDrone extends PositionComponent with HasGameReference<GRunnerGame> {
  int hp = bossDroneHp;
  double _shootTimer = 1.5;
  double _hitFlashTimer = 0;

  BossDrone({required Vector2 position})
      : super(
          position: position,
          size: Vector2(20, 20),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);

    if (_hitFlashTimer > 0) _hitFlashTimer -= dt;

    // Simple shooting
    _shootTimer -= dt;
    if (_shootTimer <= 0) {
      _shootTimer = 2.0;
      game.spawnEnemyBullet(position.x, position.y + size.y / 2, 10);
    }

    if (position.y > game.logicalHeight + 50) {
      removeFromParent();
    }
  }

  void takeDamage(int damage) {
    hp -= damage;
    _hitFlashTimer = 0.1;
    if (hp <= 0) {
      // Use stationary color for particle
      spawnKillParticles(
        (p) => game.world.add(p),
        position.x,
        position.y,
        const Color(0xFF8844FF),
      );
      game.score += enemyKillScore;
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;
    final cx = w / 2;

    final color = _hitFlashTimer > 0
        ? const Color(0xFFFFFFFF)
        : const Color(0xFFAA66FF);

    final path = Path()
      ..moveTo(cx, 0)
      ..lineTo(w, h * 0.5)
      ..lineTo(cx, h)
      ..lineTo(0, h * 0.5)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawPath(path, Paint()..color = color);
  }
}
