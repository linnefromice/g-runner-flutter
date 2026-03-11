import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import '../data/constants.dart';
import '../data/stage_data.dart';
import '../g_runner_game.dart';
import 'bullet.dart';

class Enemy extends PositionComponent with HasGameReference<GRunnerGame> {
  final EnemyType type;
  int hp;
  final int maxHp;
  final int atk;
  final double shootInterval;
  final double moveSpeed;

  double shootTimer;
  double _patrolDirection = 1;

  // Hit flash
  double _hitFlashTimer = 0;

  // Movement timer (used for sine waves, etc.)
  double _moveTimer = 0;

  // Juggernaut turret index (round-robin 0-2)
  int _turretIndex = 0;

  // Dodger evasion
  double _dodgeCooldown = 0;
  double _dodgeVx = 0;

  // Summoner/Carrier spawn timer
  double _spawnTimer = 0;

  Enemy({
    required this.type,
    required Vector2 position,
  })  : hp = _statsFor(type).hp,
        maxHp = _statsFor(type).hp,
        atk = _statsFor(type).atk,
        shootInterval = _statsFor(type).shootInterval,
        moveSpeed = _statsFor(type).moveSpeed,
        shootTimer = _statsFor(type).shootInterval > 0
            ? _statsFor(type).shootInterval * 0.5
            : 0,
        super(
          position: position,
          size: _sizeFor(type),
          anchor: Anchor.center,
        ) {
    // Init spawn timers
    if (type == EnemyType.summoner) _spawnTimer = summonerSpawnInterval;
    if (type == EnemyType.carrier) _spawnTimer = carrierSpawnInterval;
  }

  static EnemyStats _statsFor(EnemyType type) {
    switch (type) {
      case EnemyType.stationary:
        return stationaryStats;
      case EnemyType.patrol:
        return patrolStats;
      case EnemyType.rush:
        return rushStats;
      case EnemyType.swarm:
        return swarmStats;
      case EnemyType.phalanx:
        return phalanxStats;
      case EnemyType.juggernaut:
        return juggernautStats;
      case EnemyType.dodger:
        return dodgerStats;
      case EnemyType.splitter:
        return splitterStats;
      case EnemyType.summoner:
        return summonerStats;
      case EnemyType.sentinel:
        return sentinelStats;
      case EnemyType.carrier:
        return carrierStats;
    }
  }

  static Vector2 _sizeFor(EnemyType type) {
    switch (type) {
      case EnemyType.swarm:
        return Vector2(16, 16);
      case EnemyType.phalanx:
        return Vector2(36, 36);
      case EnemyType.juggernaut:
        return Vector2(56, 48);
      case EnemyType.splitter:
        return Vector2(32, 32);
      case EnemyType.summoner:
        return Vector2(36, 36);
      case EnemyType.sentinel:
        return Vector2(36, 36);
      case EnemyType.carrier:
        return Vector2(34, 34);
      case EnemyType.dodger:
        return Vector2(28, 28);
      default:
        return Vector2(28, 28);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    _moveTimer += dt;

    switch (type) {
      case EnemyType.rush:
        _updateRush(dt);
      case EnemyType.swarm:
        _updateSwarm(dt);
      case EnemyType.phalanx:
        _updatePhalanx(dt);
      case EnemyType.juggernaut:
        _updateJuggernaut(dt);
      case EnemyType.dodger:
        _updateDodger(dt);
      case EnemyType.splitter:
        _updateSplitter(dt);
      case EnemyType.summoner:
        _updateSummoner(dt);
      case EnemyType.sentinel:
        _updateSentinel(dt);
      case EnemyType.carrier:
        _updateCarrier(dt);
      default:
        _updateDefault(dt);
    }

    // Hit flash decay
    if (_hitFlashTimer > 0) {
      _hitFlashTimer -= dt;
    }

    // Remove when off screen
    if (position.y > game.logicalHeight + 50) {
      removeFromParent();
    }
  }

  // --- Existing update methods ---

  void _updateDefault(double dt) {
    position.y += game.currentScrollSpeed * dt;

    if (type == EnemyType.patrol) {
      position.x += moveSpeed * _patrolDirection * dt;
      if (position.x <= size.x / 2 || position.x >= logicalWidth - size.x / 2) {
        _patrolDirection *= -1;
        position.x = position.x.clamp(size.x / 2, logicalWidth - size.x / 2);
      }
    }

    if (shootInterval > 0) {
      shootTimer -= dt;
      if (shootTimer <= 0) {
        shootTimer = shootInterval;
        if (type == EnemyType.patrol) {
          _fireAimedShot();
        } else {
          game.spawnEnemyBullet(position.x, position.y + size.y / 2, atk);
        }
      }
    }
  }

  void _updateRush(double dt) {
    position.y += moveSpeed * dt;
    final dx = game.player.position.x - position.x;
    final chaseSpeed = moveSpeed * 0.5;
    if (dx.abs() > 1) {
      position.x += dx.sign * math.min(dx.abs(), chaseSpeed * dt);
    }
  }

  void _updateSwarm(double dt) {
    position.y += game.currentScrollSpeed * dt;
    position.x += math.cos(_moveTimer * swarmSineFrequency) * swarmSineAmplitude * dt;
    position.x = position.x.clamp(size.x / 2, logicalWidth - size.x / 2);
  }

  void _updatePhalanx(double dt) {
    position.y += game.currentScrollSpeed * dt;
    position.x += moveSpeed * _patrolDirection * dt;
    if (position.x <= size.x / 2 || position.x >= logicalWidth - size.x / 2) {
      _patrolDirection *= -1;
      position.x = position.x.clamp(size.x / 2, logicalWidth - size.x / 2);
    }
    if (shootInterval > 0) {
      shootTimer -= dt;
      if (shootTimer <= 0) {
        shootTimer = shootInterval;
        _fireSpreadShot();
      }
    }
  }

  // --- New enemy update methods ---

  void _updateJuggernaut(double dt) {
    // Slow descent
    position.y += game.currentScrollSpeed * juggernautScrollFactor * dt;
    // Sine wave horizontal
    position.x += math.sin(_moveTimer * 1.5) * juggernautSineAmplitude * dt;
    position.x = position.x.clamp(size.x / 2, logicalWidth - size.x / 2);

    // 3-turret round-robin shooting
    shootTimer -= dt;
    if (shootTimer <= 0) {
      shootTimer = shootInterval;
      final offsets = [0.2, 0.5, 0.8];
      final turretX = position.x - size.x / 2 + size.x * offsets[_turretIndex];
      game.spawnEnemyBullet(turretX, position.y + size.y / 2, atk);
      _turretIndex = (_turretIndex + 1) % 3;
    }
  }

  void _updateDodger(double dt) {
    // Scroll down slowly
    position.y += game.currentScrollSpeed * dt;

    // Evasion cooldown
    if (_dodgeCooldown > 0) {
      _dodgeCooldown -= dt;
      // Apply dodge movement
      if (_dodgeVx != 0) {
        position.x += _dodgeVx * dt;
        position.x = position.x.clamp(size.x / 2, logicalWidth - size.x / 2);
      }
    } else {
      _dodgeVx = 0;
      // Detect incoming player bullets
      final bullets = game.world.children.whereType<PlayerBullet>();
      for (final bullet in bullets) {
        if (!bullet.isMounted) continue;
        final dx = bullet.position.x - position.x;
        final dy = position.y - bullet.position.y; // bullet is above
        if (dy > 0 && dy < dodgerDetectRange && dx.abs() < dodgerDetectRadius) {
          // Dodge away from bullet
          _dodgeVx = dx >= 0 ? -moveSpeed : moveSpeed;
          _dodgeCooldown = dodgerCooldown;
          break;
        }
      }
    }

    // Aimed shooting
    if (shootInterval > 0) {
      shootTimer -= dt;
      if (shootTimer <= 0) {
        shootTimer = shootInterval;
        _fireAimedShot();
      }
    }
  }

  void _updateSplitter(double dt) {
    // Standard scroll
    position.y += game.currentScrollSpeed * dt;
    // Straight down shooting
    if (shootInterval > 0) {
      shootTimer -= dt;
      if (shootTimer <= 0) {
        shootTimer = shootInterval;
        game.spawnEnemyBullet(position.x, position.y + size.y / 2, atk);
      }
    }
  }

  void _updateSummoner(double dt) {
    // Stationary — just scroll
    position.y += game.currentScrollSpeed * dt;

    // Spawn swarms periodically
    _spawnTimer -= dt;
    if (_spawnTimer <= 0) {
      _spawnTimer = summonerSpawnInterval;
      // Check max active swarms
      final swarmCount = game.world.children
          .whereType<Enemy>()
          .where((e) => e.type == EnemyType.swarm)
          .length;
      if (swarmCount < summonerMaxSpawns) {
        game.world.add(Enemy(
          type: EnemyType.swarm,
          position: Vector2(position.x - 20, position.y + size.y / 2 + 10),
        ));
        game.world.add(Enemy(
          type: EnemyType.swarm,
          position: Vector2(position.x + 20, position.y + size.y / 2 + 10),
        ));
      }
    }
  }

  void _updateSentinel(double dt) {
    // Stationary scroll
    position.y += game.currentScrollSpeed * dt;

    // 3-way spread shot
    if (shootInterval > 0) {
      shootTimer -= dt;
      if (shootTimer <= 0) {
        shootTimer = shootInterval;
        _fireSpreadShot();
      }
    }
  }

  void _updateCarrier(double dt) {
    // Slow descent
    position.y += game.currentScrollSpeed * carrierScrollFactor * dt;

    // Horizontal patrol
    position.x += moveSpeed * _patrolDirection * dt;
    if (position.x <= size.x / 2 || position.x >= logicalWidth - size.x / 2) {
      _patrolDirection *= -1;
      position.x = position.x.clamp(size.x / 2, logicalWidth - size.x / 2);
    }

    // Spawn patrol enemies periodically
    _spawnTimer -= dt;
    if (_spawnTimer <= 0) {
      _spawnTimer = carrierSpawnInterval;
      game.world.add(Enemy(
        type: EnemyType.patrol,
        position: Vector2(position.x - 25, position.y + size.y / 2 + 10),
      ));
      game.world.add(Enemy(
        type: EnemyType.patrol,
        position: Vector2(position.x + 25, position.y + size.y / 2 + 10),
      ));
    }
  }

  // --- Shooting helpers ---

  void _fireAimedShot() {
    final dx = game.player.position.x - position.x;
    final dy = game.player.position.y - position.y;
    final dist = math.sqrt(dx * dx + dy * dy);
    if (dist > 0) {
      final vx = (dx / dist) * enemyBulletSpeed;
      final vy = (dy / dist) * enemyBulletSpeed;
      game.spawnEnemyBullet(position.x, position.y + size.y / 2, atk,
          speedX: vx, speedY: vy);
    }
  }

  void _fireSpreadShot() {
    game.spawnEnemyBullet(position.x, position.y + size.y / 2, atk);
    const angle = 30 * math.pi / 180;
    final leftVx = -math.sin(angle) * enemyBulletSpeed;
    final leftVy = math.cos(angle) * enemyBulletSpeed;
    game.spawnEnemyBullet(position.x, position.y + size.y / 2, atk,
        speedX: leftVx, speedY: leftVy);
    final rightVx = math.sin(angle) * enemyBulletSpeed;
    final rightVy = math.cos(angle) * enemyBulletSpeed;
    game.spawnEnemyBullet(position.x, position.y + size.y / 2, atk,
        speedX: rightVx, speedY: rightVy);
  }

  // --- Damage ---

  void takeDamage(int damage, {double? bulletCenterY}) {
    int actualDamage = damage;

    // Phalanx shield: upper half blocks with damage reduction
    if (type == EnemyType.phalanx && bulletCenterY != null) {
      if (bulletCenterY < position.y) {
        actualDamage = (damage * phalanxShieldDamageMultiplier).round();
      }
    }

    // Sentinel: all damage reduced by shield
    if (type == EnemyType.sentinel) {
      actualDamage = (damage * sentinelShieldReduction).round();
    }

    hp -= actualDamage;
    _hitFlashTimer = 0.1;
    if (hp <= 0) {
      game.onEnemyKilled(this);
      removeFromParent();
    }
  }

  // --- Rendering ---

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;
    final cx = w / 2;

    final bool isFlashing = _hitFlashTimer > 0;
    final depthScale = _depthScale();

    canvas.save();
    canvas.translate(cx, h / 2);
    canvas.scale(depthScale, depthScale);
    canvas.translate(-cx, -h / 2);

    final Color bodyColor;
    if (isFlashing) {
      bodyColor = const Color(0xFFFFFFFF);
    } else {
      bodyColor = colorForType;
    }

    switch (type) {
      case EnemyType.rush:
        _renderRush(canvas, w, h, bodyColor);
      case EnemyType.swarm:
        _renderSwarm(canvas, w, h, bodyColor);
      case EnemyType.phalanx:
        _renderPhalanx(canvas, w, h, bodyColor);
      case EnemyType.juggernaut:
        _renderJuggernaut(canvas, w, h, bodyColor);
      case EnemyType.sentinel:
        _renderSentinel(canvas, w, h, bodyColor);
      default:
        // Diamond for dodger, splitter, summoner, carrier; inverted triangle for stationary/patrol
        if (type == EnemyType.dodger ||
            type == EnemyType.splitter ||
            type == EnemyType.summoner ||
            type == EnemyType.carrier) {
          _renderDiamond(canvas, w, h, bodyColor);
        } else {
          _renderDefault(canvas, w, h, cx, bodyColor);
        }
    }

    // HP bar (skip for swarm — 1HP enemies)
    if (type != EnemyType.swarm && hp < maxHp) {
      final hpRatio = hp / maxHp;
      final barWidth = w;
      const barHeight = 3.0;
      const barY = -6.0;

      canvas.drawRect(
        Rect.fromLTWH(0, barY, barWidth, barHeight),
        Paint()..color = const Color(0x88000000),
      );
      canvas.drawRect(
        Rect.fromLTWH(0, barY, barWidth * hpRatio, barHeight),
        Paint()..color = const Color(0xFF44FF44),
      );
    }

    canvas.restore();
  }

  void _renderDefault(Canvas canvas, double w, double h, double cx, Color bodyColor) {
    final bodyPath = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(cx, h)
      ..close();
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = bodyColor.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawPath(bodyPath, Paint()..color = bodyColor);
  }

  void _renderRush(Canvas canvas, double w, double h, Color bodyColor) {
    final cx = w / 2;
    final bodyPath = Path()
      ..moveTo(cx, 0)
      ..lineTo(w * 0.8, h * 0.3)
      ..lineTo(w * 0.6, h)
      ..lineTo(w * 0.4, h)
      ..lineTo(w * 0.2, h * 0.3)
      ..close();
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = bodyColor.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawPath(bodyPath, Paint()..color = bodyColor);
  }

  void _renderSwarm(Canvas canvas, double w, double h, Color bodyColor) {
    _renderDiamond(canvas, w, h, bodyColor, blurRadius: 3);
  }

  void _renderDiamond(Canvas canvas, double w, double h, Color bodyColor,
      {double blurRadius = 4}) {
    final cx = w / 2;
    final cy = h / 2;
    final bodyPath = Path()
      ..moveTo(cx, 0)
      ..lineTo(w, cy)
      ..lineTo(cx, h)
      ..lineTo(0, cy)
      ..close();
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = bodyColor.withValues(alpha: 0.3)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius),
    );
    canvas.drawPath(bodyPath, Paint()..color = bodyColor);
  }

  void _renderPhalanx(Canvas canvas, double w, double h, Color bodyColor) {
    final cx = w / 2;
    final bodyPath = Path()
      ..moveTo(cx * 0.3, 0)
      ..lineTo(w - cx * 0.3, 0)
      ..lineTo(w, h * 0.5)
      ..lineTo(w - cx * 0.3, h)
      ..lineTo(cx * 0.3, h)
      ..lineTo(0, h * 0.5)
      ..close();
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = bodyColor.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawPath(bodyPath, Paint()..color = bodyColor);

    if (!(_hitFlashTimer > 0)) {
      final shieldPath = Path()
        ..moveTo(cx * 0.3, 0)
        ..lineTo(w - cx * 0.3, 0)
        ..lineTo(w, h * 0.5)
        ..lineTo(0, h * 0.5)
        ..close();
      canvas.drawPath(shieldPath, Paint()..color = const Color(0x4444AAFF));
    }
  }

  void _renderJuggernaut(Canvas canvas, double w, double h, Color bodyColor) {
    // Large hexagon
    final cx = w / 2;
    final bodyPath = Path()
      ..moveTo(cx * 0.3, 0)
      ..lineTo(w - cx * 0.3, 0)
      ..lineTo(w, h * 0.35)
      ..lineTo(w, h * 0.65)
      ..lineTo(w - cx * 0.3, h)
      ..lineTo(cx * 0.3, h)
      ..lineTo(0, h * 0.65)
      ..lineTo(0, h * 0.35)
      ..close();
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = bodyColor.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawPath(bodyPath, Paint()..color = bodyColor);
  }

  void _renderSentinel(Canvas canvas, double w, double h, Color bodyColor) {
    // Pentagon turret shape
    final cx = w / 2;
    final bodyPath = Path()
      ..moveTo(cx, 0)
      ..lineTo(w, h * 0.4)
      ..lineTo(w * 0.8, h)
      ..lineTo(w * 0.2, h)
      ..lineTo(0, h * 0.4)
      ..close();
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = bodyColor.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawPath(bodyPath, Paint()..color = bodyColor);

    // Shield overlay (full body)
    if (!(_hitFlashTimer > 0)) {
      canvas.drawPath(bodyPath, Paint()..color = const Color(0x2244AAFF));
    }
  }

  Color get colorForType {
    switch (type) {
      case EnemyType.stationary:
        return const Color(0xFFFF6644);
      case EnemyType.patrol:
        return const Color(0xFFFFAA22);
      case EnemyType.rush:
        return const Color(0xFFFF2244);
      case EnemyType.swarm:
        return const Color(0xFF88FF44);
      case EnemyType.phalanx:
        return const Color(0xFF4488FF);
      case EnemyType.juggernaut:
        return const Color(0xFFAA44FF);
      case EnemyType.dodger:
        return const Color(0xFF44DDFF);
      case EnemyType.splitter:
        return const Color(0xFFFF8800);
      case EnemyType.summoner:
        return const Color(0xFFDDAA00);
      case EnemyType.sentinel:
        return const Color(0xFFFF4466);
      case EnemyType.carrier:
        return const Color(0xFF88CC44);
    }
  }

  double _depthScale() {
    final normalizedY = (position.y / game.logicalHeight).clamp(0.0, 1.0);
    return 0.75 + normalizedY * 0.25;
  }
}
