import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'components/background.dart';
import 'components/boost_lane.dart';
import 'components/boss.dart';
import 'components/bullet.dart';
import 'components/debris.dart';
import 'components/enemy.dart';
import 'components/ex_burst.dart';
import 'components/gate.dart';
import 'components/particle.dart';
import 'components/player.dart';
import 'components/score_popup.dart';
import 'data/constants.dart';
import 'data/difficulty.dart';
import 'data/endless_data.dart';
import 'data/form_skills.dart';
import 'data/stage_data.dart';

enum GameState { playing, paused, gameOver, stageClear }

class GRunnerGame extends FlameGame {
  StageData stageData;
  final bool isEndless;

  late Player player;
  late Background background;

  GameState state = GameState.playing;
  int score = 0;
  double stageTime = 0;
  int _spawnIndex = 0;

  // Callback for game end (navigates to result screen)
  void Function(GameState state, int score)? onGameEnd;

  // Endless mode
  int endlessWave = 0;
  final math.Random _endlessRng = math.Random();
  BoostLane? _activeBoostLane;
  bool isInBoostLane = false;

  // Screen shake
  double _shakeIntensity = 0;
  double _shakeTimer = 0;
  final math.Random _shakeRng = math.Random();

  // Combo & Awakening
  int comboCount = 0;
  bool isAwakened = false;
  double awakenedTimer = 0;
  double _slowMotionTimer = 0;
  double _slowMotionFactor = 1.0;

  // EX Burst
  double exGauge = 0;
  bool isExBurstActive = false;

  // Transform system
  double transformGauge = 0;
  FormType primaryForm = FormType.standard;
  FormType secondaryForm = FormType.heavyArtillery;
  bool _isOnPrimaryForm = true;

  FormType get currentFormType => _isOnPrimaryForm ? primaryForm : secondaryForm;

  // Boss
  Boss? currentBoss;
  bool isBossPhase = false;

  // Upgrade bonuses (set from GameProgress before game starts)
  int upgradeBonusAtk = 0;
  int upgradeBonusHp = 0;
  double upgradeBonusSpeedMultiplier = 1.0;
  double upgradeBonusDefMultiplier = 1.0;

  // Credits earned during this session
  int creditsEarned = 0;

  // Bonus tracking
  int damageTaken = 0;
  int awakenedCount = 0;
  int enemiesSpawned = 0;
  int enemiesKilled = 0;

  // Form XP earned this session
  int formXpEarned = 0;

  // Graze tracking
  int grazeCount = 0;

  // Parry (Just Transform)
  double parryTimer = 0; // remaining parry window time

  // Difficulty scaling
  late final DifficultyParams difficulty;

  double get logicalHeight => logicalWidth * (size.y / size.x);

  double get currentScrollSpeed {
    double base;
    if (isEndless) {
      final endlessDiff = getEndlessDifficulty(stageTime);
      base = baseScrollSpeed * endlessDiff.scrollSpeedMultiplier;
    } else {
      base = baseScrollSpeed * difficulty.scrollSpeedMultiplier;
    }
    if (isBossPhase) base *= bossScrollSpeedMultiplier;
    if (isInBoostLane) base *= boostLaneScrollMultiplier;
    return base;
  }

  double get _scale => size.x / logicalWidth;

  GRunnerGame({required this.stageData, this.isEndless = false}) {
    difficulty = getDifficultyForStage(isEndless ? 1 : stageData.id);
  }

  @override
  Future<void> onLoad() async {
    camera.viewfinder.visibleGameSize = Vector2(logicalWidth, logicalHeight);
    camera.viewfinder.anchor = Anchor.topLeft;

    background = Background();
    world.add(background);

    player = Player();
    player.position = Vector2(logicalWidth / 2, logicalHeight * 0.75);
    // Apply upgrade bonuses
    player.atk += upgradeBonusAtk;
    player.hp += upgradeBonusHp;
    player.maxHp += upgradeBonusHp;
    player.speedMultiplier *= upgradeBonusSpeedMultiplier;
    player.defMultiplier = upgradeBonusDefMultiplier;
    world.add(player);
  }

  @override
  void update(double dt) {
    if (state != GameState.playing) return;

    // Apply slow motion factor
    final effectiveDt = dt * _slowMotionFactor;
    if (_slowMotionTimer > 0) {
      _slowMotionTimer -= dt; // real time, not slowed
      if (_slowMotionTimer <= 0) {
        _slowMotionFactor = 1.0;
      }
    }

    super.update(effectiveDt);

    stageTime += effectiveDt;
    _updateScreenShake(effectiveDt);
    _updateAwakening(effectiveDt);
    _updateTransformGauge(effectiveDt);
    if (parryTimer > 0) {
      parryTimer -= dt; // real time, not slowed
    }

    _processSpawnEvents();
    _checkCollisions();
    _checkContactDamage();
    _checkGateCollisions();
    _checkDebrisCollisions();
    _updateBoostLane();

    // Endless: generate next wave
    if (isEndless) {
      final nextWaveTime = (endlessWave + 1) * endlessWaveDuration;
      if (stageTime >= nextWaveTime) {
        endlessWave++;
        final newEvents = generateEndlessWave(endlessWave, _endlessRng);
        stageData = StageData(
          id: 0,
          name: 'Endless',
          duration: double.infinity,
          timeline: [...stageData.timeline, ...newEvents],
        );
      }
    }

    if (player.hp <= 0) {
      state = GameState.gameOver;
      onGameEnd?.call(state, score);
    }

    // Stage clear: boss stages clear on boss defeat, normal stages clear when time + enemies done
    if (!isEndless && !stageData.hasBoss && stageTime >= stageData.duration) {
      final enemies = world.children.whereType<Enemy>();
      if (enemies.isEmpty) {
        creditsEarned += creditPerStageClear;
        state = GameState.stageClear;
        onGameEnd?.call(state, score);
      }
    }
  }

  // --- Combo & Awakening ---

  void incrementCombo() {
    comboCount++;
    if (comboCount >= comboThreshold && !isAwakened) {
      _activateAwakening();
    }
  }

  void resetCombo() {
    comboCount = 0;
  }

  void _activateAwakening() {
    isAwakened = true;
    awakenedTimer = awakenedDuration;
    awakenedCount++;
    comboCount = 0;

    // Slow motion effect
    _slowMotionFactor = awakenedSlowMotionFactor;
    _slowMotionTimer = awakenedSlowMotionDuration;

    // Apply awakening buffs to player
    player.awakenedAtkMultiplier = awakenedAtkMultiplier;
    player.awakenedSpeedMultiplier = awakenedSpeedMultiplier;
    player.awakenedFireRateMultiplier = awakenedFireRateMultiplier;
    player.isAwakenedInvincible = true;
    player.isAwakened = true;
  }

  void _deactivateAwakening() {
    isAwakened = false;
    awakenedTimer = 0;
    comboCount = 0;

    player.awakenedAtkMultiplier = 1.0;
    player.awakenedSpeedMultiplier = 1.0;
    player.awakenedFireRateMultiplier = 1.0;
    player.isAwakenedInvincible = false;
    player.isAwakened = false;
  }

  void _updateAwakening(double dt) {
    if (!isAwakened) return;
    awakenedTimer -= dt;
    if (awakenedTimer <= 0) {
      _deactivateAwakening();
    }
  }

  bool get awakenedWarning => isAwakened && awakenedTimer <= awakenedWarningTime;

  // --- EX Burst ---

  void addExGauge(double amount) {
    if (isExBurstActive) return;
    exGauge = (exGauge + amount).clamp(0, exGaugeMax);
  }

  void activateExBurst() {
    if (exGauge < exGaugeMax || isExBurstActive) return;
    exGauge = 0;
    isExBurstActive = true;
    world.add(ExBurst());
  }

  void onExBurstEnd() {
    isExBurstActive = false;
  }

  void applyExBurstDamage(double beamLeft, double beamRight, double beamBottom) {
    // Damage enemies in beam
    final enemies = world.children.whereType<Enemy>().toList();
    for (final enemy in enemies) {
      if (!enemy.isMounted) continue;
      if (enemy.position.x >= beamLeft &&
          enemy.position.x <= beamRight &&
          enemy.position.y <= beamBottom) {
        enemy.takeDamage(exBurstDamage.toInt());
      }
    }

    // Destroy enemy bullets in beam
    final enemyBullets = world.children.whereType<EnemyBullet>().toList();
    for (final bullet in enemyBullets) {
      if (!bullet.isMounted) continue;
      if (bullet.position.x >= beamLeft &&
          bullet.position.x <= beamRight &&
          bullet.position.y <= beamBottom) {
        bullet.removeFromParent();
      }
    }

    // Damage boss in beam
    final boss = currentBoss;
    if (boss != null && boss.isMounted) {
      if (boss.position.x >= beamLeft &&
          boss.position.x <= beamRight &&
          boss.position.y <= beamBottom) {
        boss.takeDamage(exBurstDamage.toInt());
      }
    }

    // Damage boss drones in beam
    final drones = world.children.whereType<BossDrone>().toList();
    for (final drone in drones) {
      if (!drone.isMounted) continue;
      if (drone.position.x >= beamLeft &&
          drone.position.x <= beamRight &&
          drone.position.y <= beamBottom) {
        drone.takeDamage(exBurstDamage.toInt());
      }
    }

    // Destroy tradeoff gates in beam
    final gates = world.children.whereType<Gate>().toList();
    for (final gate in gates) {
      if (!gate.isMounted || gate.passed) continue;
      if (gate.effect.type == GateEffectType.tradeoffAtkUpSpdDown ||
          gate.effect.type == GateEffectType.tradeoffSpdUpAtkDown) {
        if (gate.position.x >= beamLeft &&
            gate.position.x <= beamRight &&
            gate.position.y <= beamBottom) {
          gate.removeFromParent();
        }
      }
    }
  }

  // --- Transform System ---

  void _updateTransformGauge(double dt) {
    if (isExBurstActive || isAwakened) return;
    // Passive gauge gain
    addTransformGauge(transformGainPerSecond * dt);
  }

  void addTransformGauge(double amount) {
    if (isAwakened) return;
    transformGauge = (transformGauge + amount).clamp(0, transformGaugeMax);
  }

  FormDefinition _formDefinitionFor(FormType type) {
    switch (type) {
      case FormType.standard:
        return formStandard;
      case FormType.heavyArtillery:
        return formHeavyArtillery;
      case FormType.highSpeed:
        return formHighSpeed;
      case FormType.sniper:
        return formSniper;
      case FormType.scatter:
        return formScatter;
      case FormType.guardian:
        return formGuardian;
    }
  }

  void activateTransform() {
    if (transformGauge < transformGaugeMax || isAwakened) return;
    transformGauge = 0;
    _isOnPrimaryForm = !_isOnPrimaryForm;
    final newFormType = _isOnPrimaryForm ? primaryForm : secondaryForm;
    player.currentForm = _formDefinitionFor(newFormType);
    player.applyTransformBonus();
    // Start parry window
    parryTimer = parryWindow;
  }

  void handleTransformTap() {
    if (state != GameState.playing) return;
    activateTransform();
  }

  // --- Boss ---

  void onBossPhaseStarted() {
    isBossPhase = true;
  }

  void onBossDefeated(Boss boss) {
    isBossPhase = false;
    currentBoss = null;
    score += bossKillScore;
    creditsEarned += creditPerBossDefeat;
    creditsEarned += creditPerStageClear;
    _spawnScorePopup(bossKillScore, boss.position.x, boss.position.y);
    triggerShake(bossDeathShakeIntensity, bossDeathShakeDuration);

    // Big explosion particles (16 directions)
    spawnKillParticles(
      (p) => world.add(p),
      boss.position.x,
      boss.position.y,
      const Color(0xFFFF2244),
    );

    state = GameState.stageClear;
    onGameEnd?.call(state, score);
  }

  // --- Spawn Events ---

  void _processSpawnEvents() {
    final timeline = stageData.timeline;
    while (_spawnIndex < timeline.length &&
        timeline[_spawnIndex].time <= stageTime) {
      final event = timeline[_spawnIndex];
      switch (event.type) {
        case SpawnEventType.enemy:
          if (!isBossPhase) {
            enemiesSpawned++;
            world.add(Enemy(
              type: event.enemyType!,
              position: Vector2(event.x!, -20),
              hpMultiplier: difficulty.enemyHpMultiplier,
              atkMultiplier: difficulty.enemyAtkMultiplier,
              attackIntervalMultiplier: difficulty.attackIntervalMultiplier,
            ));
          }
        case SpawnEventType.gate:
          if (!isBossPhase) {
            final leftX = gateWidth / 2;
            final rightX = logicalWidth - gateWidth / 2;
            world.add(Gate(
              effect: event.leftEffect!,
              isLeft: true,
              position: Vector2(leftX, -gateHeight),
            ));
            world.add(Gate(
              effect: event.rightEffect!,
              isLeft: false,
              position: Vector2(rightX, -gateHeight),
            ));
          }
        case SpawnEventType.boss:
          final boss = Boss(bossIndex: event.bossIndex);
          currentBoss = boss;
          world.add(boss);
        case SpawnEventType.debris:
          if (!isBossPhase) {
            world.add(Debris(position: Vector2(event.x!, -debrisHeight)));
          }
        case SpawnEventType.boostLaneStart:
          if (!isBossPhase) {
            _removeBoostLane();
            final lane = BoostLane(
              laneX: event.x!,
              laneWidth: event.boostLaneWidth!,
            );
            _activeBoostLane = lane;
            world.add(lane);
          }
        case SpawnEventType.boostLaneEnd:
          _removeBoostLane();
      }
      _spawnIndex++;
    }
  }

  void _removeBoostLane() {
    if (_activeBoostLane != null && _activeBoostLane!.isMounted) {
      _activeBoostLane!.removeFromParent();
    }
    _activeBoostLane = null;
    isInBoostLane = false;
  }

  void _updateBoostLane() {
    if (_activeBoostLane != null && _activeBoostLane!.isMounted) {
      isInBoostLane = _activeBoostLane!.containsPlayer();
    } else {
      isInBoostLane = false;
    }
  }

  void _checkDebrisCollisions() {
    final debrisList = world.children.whereType<Debris>().toList();
    final playerBullets = world.children.whereType<PlayerBullet>().toList();
    final playerHitbox = player.hitbox;

    for (final debris in debrisList) {
      if (!debris.isMounted) continue;
      final debrisRect = Rect.fromCenter(
        center: Offset(debris.position.x, debris.position.y),
        width: debris.size.x,
        height: debris.size.y,
      );

      // Player collision (contact damage)
      if (debrisRect.overlaps(playerHitbox)) {
        if (!player.isInvincible && !player.isAwakenedInvincible) {
          triggerShake(shakePlayerHitIntensity, shakePlayerHitDuration);
          player.takeDamage(debrisContactDamage);
          damageTaken += debrisContactDamage;
          resetCombo();
        }
      }

      // Bullet collision
      for (final bullet in playerBullets) {
        if (!bullet.isMounted) continue;
        final bulletRect = Rect.fromCenter(
          center: Offset(bullet.position.x, bullet.position.y),
          width: bullet.size.x,
          height: bullet.size.y,
        );
        if (bulletRect.overlaps(debrisRect)) {
          debris.takeDamage(bullet.damage);
          if (!bullet.isPierce) {
            bullet.removeFromParent();
          }
          break;
        }
      }
    }
  }

  void onDebrisDestroyed(Debris debris) {
    score += debrisDestroyScore;
    creditsEarned += debrisDestroyCredit;
    _spawnScorePopup(debrisDestroyScore, debris.position.x, debris.position.y);
    spawnKillParticles(
      (p) => world.add(p),
      debris.position.x,
      debris.position.y,
      const Color(0xFF8899AA),
    );
  }

  // --- Collision Detection ---

  void _checkCollisions() {
    final playerBullets = world.children.whereType<PlayerBullet>().toList();
    final enemies = world.children.whereType<Enemy>().toList();
    final enemyBullets = world.children.whereType<EnemyBullet>().toList();

    for (final bullet in playerBullets) {
      if (!bullet.isMounted) continue;
      final bulletRect = Rect.fromCenter(
        center: Offset(bullet.position.x, bullet.position.y),
        width: bullet.size.x,
        height: bullet.size.y,
      );

      if (bullet.bulletType == BulletType.explosion) {
        // Explosion bullet: on first hit, deal AoE damage to all enemies in radius
        for (final enemy in enemies) {
          if (!enemy.isMounted) continue;
          final enemyRect = Rect.fromCenter(
            center: Offset(enemy.position.x, enemy.position.y),
            width: enemy.size.x,
            height: enemy.size.y,
          );
          if (bulletRect.overlaps(enemyRect)) {
            // AoE damage to all enemies within explosion radius
            _applyExplosionDamage(
                bullet.position.x, bullet.position.y, bullet.damage);
            bullet.removeFromParent();
            break;
          }
        }
      } else if (bullet.isPierce) {
        // Pierce bullet: passes through enemies, hitting each once
        for (final enemy in enemies) {
          if (!enemy.isMounted) continue;
          final enemyRect = Rect.fromCenter(
            center: Offset(enemy.position.x, enemy.position.y),
            width: enemy.size.x,
            height: enemy.size.y,
          );
          if (bulletRect.overlaps(enemyRect)) {
            enemy.takeDamage(bullet.damage, bulletCenterY: bullet.position.y);
          }
        }
      } else {
        // Normal / shieldPierce / scatter bullet
        for (final enemy in enemies) {
          if (!enemy.isMounted) continue;
          final enemyRect = Rect.fromCenter(
            center: Offset(enemy.position.x, enemy.position.y),
            width: enemy.size.x,
            height: enemy.size.y,
          );
          if (bulletRect.overlaps(enemyRect)) {
            enemy.takeDamage(
              bullet.damage,
              bulletCenterY: bullet.position.y,
              shieldPierce: bullet.isShieldPierce,
            );
            bullet.removeFromParent();
            break;
          }
        }
      }
    }

    // Player bullets → Boss
    final boss = currentBoss;
    if (boss != null && boss.isMounted && boss.phase != BossPhase.entering) {
      final bossRect = Rect.fromCenter(
        center: Offset(boss.position.x, boss.position.y),
        width: boss.size.x,
        height: boss.size.y,
      );
      for (final bullet in playerBullets) {
        if (!bullet.isMounted) continue;
        final bulletRect = Rect.fromCenter(
          center: Offset(bullet.position.x, bullet.position.y),
          width: bullet.size.x,
          height: bullet.size.y,
        );
        if (bulletRect.overlaps(bossRect)) {
          boss.takeDamage(bullet.damage);
          if (!bullet.isPierce) {
            bullet.removeFromParent();
          }
        }
      }
    }

    // Player bullets → Boss Drones
    final drones = world.children.whereType<BossDrone>().toList();
    for (final drone in drones) {
      if (!drone.isMounted) continue;
      final droneRect = Rect.fromCenter(
        center: Offset(drone.position.x, drone.position.y),
        width: drone.size.x,
        height: drone.size.y,
      );
      for (final bullet in playerBullets) {
        if (!bullet.isMounted) continue;
        final bulletRect = Rect.fromCenter(
          center: Offset(bullet.position.x, bullet.position.y),
          width: bullet.size.x,
          height: bullet.size.y,
        );
        if (bulletRect.overlaps(droneRect)) {
          drone.takeDamage(bullet.damage);
          if (!bullet.isPierce) {
            bullet.removeFromParent();
          }
        }
      }
    }

    final playerHitbox = player.hitbox;
    // Visual hitbox for graze detection (player visual size)
    final playerVisualRect = Rect.fromCenter(
      center: Offset(player.position.x, player.position.y),
      width: playerWidth,
      height: playerHeight,
    );

    for (final bullet in enemyBullets) {
      if (!bullet.isMounted) continue;
      final bulletRect = Rect.fromCenter(
        center: Offset(bullet.position.x, bullet.position.y),
        width: bullet.size.x,
        height: bullet.size.y,
      );

      if (bulletRect.overlaps(playerHitbox)) {
        // Direct hit — check for parry first
        if (parryTimer > 0) {
          _applyParryShockwave(bullet.position.x, bullet.position.y);
          bullet.removeFromParent();
          continue;
        }
        if (!player.isInvincible && !player.isAwakenedInvincible) {
          triggerShake(shakePlayerHitIntensity, shakePlayerHitDuration);
          player.takeDamage(bullet.damage);
          damageTaken += bullet.damage;
          resetCombo();
        }
        bullet.removeFromParent();
      } else if (!bullet.grazed &&
          !player.isInvincible &&
          !player.isAwakenedInvincible &&
          bulletRect.overlaps(playerVisualRect)) {
        // Graze: bullet overlaps visual rect but not actual hitbox
        bullet.grazed = true;
        _applyGraze(bullet);
      }
    }
  }

  void _applyGraze(EnemyBullet bullet) {
    // Calculate graze tier based on distance
    final dx = bullet.position.x - player.position.x;
    final dy = bullet.position.y - player.position.y;
    final dist = math.sqrt(dx * dx + dy * dy);
    final halfHitbox = playerHitboxSize / 2;

    int grazeScore;
    double exGain;
    double tfGain;
    int xpGain;

    if (dist <= halfHitbox + grazeExtremeExpand) {
      // Extreme graze
      grazeScore = grazeExtremeScore;
      exGain = grazeExtremeExGain;
      tfGain = grazeExtremeTfGain;
      xpGain = xpPerGrazeExtreme;
    } else if (dist <= halfHitbox + grazeCloseExpand) {
      // Close graze
      grazeScore = grazeCloseScore;
      exGain = grazeCloseExGain;
      tfGain = grazeCloseTfGain;
      xpGain = xpPerGrazeClose;
    } else {
      // Normal graze
      grazeScore = grazeNormalScore;
      exGain = grazeNormalExGain;
      tfGain = grazeNormalTfGain;
      xpGain = xpPerGrazeNormal;
    }

    score += grazeScore;
    addExGauge(exGain);
    addTransformGauge(tfGain);
    formXpEarned += xpGain;
    grazeCount++;

    _spawnScorePopup(grazeScore, bullet.position.x, bullet.position.y);
  }

  void _applyParryShockwave(double x, double y) {
    parryTimer = 0;
    score += parryScore;
    addExGauge(parryExGain);
    triggerShake(4.0, 0.15);
    _spawnScorePopup(parryScore, x, y);

    // Damage all enemies in radius
    final enemies = world.children.whereType<Enemy>().toList();
    for (final enemy in enemies) {
      if (!enemy.isMounted) continue;
      final dx = enemy.position.x - x;
      final dy = enemy.position.y - y;
      final dist = dx * dx + dy * dy;
      if (dist <= parryShockwaveRadius * parryShockwaveRadius) {
        enemy.takeDamage(parryShockwaveDamage);
      }
    }

    // Destroy enemy bullets in radius
    final bullets = world.children.whereType<EnemyBullet>().toList();
    for (final bullet in bullets) {
      if (!bullet.isMounted) continue;
      final dx = bullet.position.x - x;
      final dy = bullet.position.y - y;
      final dist = dx * dx + dy * dy;
      if (dist <= parryShockwaveRadius * parryShockwaveRadius) {
        bullet.removeFromParent();
      }
    }

    // Shockwave particles
    spawnKillParticles(
      (p) => world.add(p),
      x, y,
      const Color(0xFFFFFFFF),
    );
  }

  void _applyExplosionDamage(double x, double y, int damage) {
    final enemies = world.children.whereType<Enemy>().toList();
    for (final enemy in enemies) {
      if (!enemy.isMounted) continue;
      final dx = enemy.position.x - x;
      final dy = enemy.position.y - y;
      final dist = dx * dx + dy * dy;
      if (dist <= explosionRadius * explosionRadius) {
        enemy.takeDamage(damage);
      }
    }
    // Spawn explosion visual (reuse particle system with larger burst)
    spawnKillParticles(
      (p) => world.add(p),
      x,
      y,
      const Color(0xFFFF6600),
    );
  }

  void _checkContactDamage() {
    final enemies = world.children.whereType<Enemy>().toList();
    final playerHitbox = player.hitbox;

    for (final enemy in enemies) {
      if (!enemy.isMounted) continue;
      if (enemy.type != EnemyType.rush && enemy.type != EnemyType.swarm) continue;

      final enemyRect = Rect.fromCenter(
        center: Offset(enemy.position.x, enemy.position.y),
        width: enemy.size.x,
        height: enemy.size.y,
      );
      if (playerHitbox.overlaps(enemyRect)) {
        if (!player.isInvincible && !player.isAwakenedInvincible) {
          triggerShake(shakePlayerHitIntensity, shakePlayerHitDuration);
          player.takeDamage(enemy.atk);
          damageTaken += enemy.atk;
          resetCombo();
        }
        // Kill the enemy on contact
        onEnemyKilled(enemy);
        enemy.removeFromParent();
      }
    }
  }

  void _checkGateCollisions() {
    final gates = world.children.whereType<Gate>().toList();
    final playerRect = Rect.fromCenter(
      center: Offset(player.position.x, player.position.y),
      width: playerWidth,
      height: playerHeight,
    );

    for (final gate in gates) {
      if (gate.passed) continue;
      final gateRect = Rect.fromCenter(
        center: Offset(gate.position.x, gate.position.y),
        width: gate.size.x,
        height: gate.size.y,
      );
      if (playerRect.overlaps(gateRect)) {
        gate.passed = true;
        _applyGateEffect(gate.effect);
        score += gatePassScore;
        _spawnScorePopup(gatePassScore, gate.position.x, gate.position.y);

        // Combo: Gate pass increments combo (non-tradeoff gates)
        if (!gate.effect.type.isTradeoff) {
          incrementCombo();
        }

        // EX gauge
        addExGauge(exGainOnGatePass);

        // Transform gauge
        addTransformGauge(transformGainOnGatePass);

        // Form XP
        formXpEarned += xpPerGatePass;
      }
    }
  }

  void _applyGateEffect(GateEffect effect) {
    switch (effect.type) {
      case GateEffectType.atkAdd:
        player.atk += effect.value.toInt();
      case GateEffectType.speedMultiply:
        player.speedMultiplier *= effect.value;
      case GateEffectType.hpRecover:
        player.hp = (player.hp + effect.value.toInt()).clamp(0, player.maxHp);
      case GateEffectType.tradeoffAtkUpSpdDown:
        player.atk += effect.value.toInt();
        player.speedMultiplier *= effect.value2!;
      case GateEffectType.tradeoffSpdUpAtkDown:
        player.speedMultiplier *= effect.value;
        player.atk = (player.atk * effect.value2!).round();
      case GateEffectType.refit:
        final formType = FormType.values[effect.value.toInt().clamp(0, FormType.values.length - 1)];
        player.currentForm = _formDefinitionFor(formType);
      case GateEffectType.growth:
        player.atk += effect.value.toInt();
      case GateEffectType.roulette:
        final isPositive = math.Random().nextBool();
        if (isPositive) {
          player.atk += effect.value.toInt();
        } else {
          player.atk = (player.atk + effect.value2!.toInt()).clamp(1, 9999);
        }
    }
  }

  // --- Spawning helpers ---

  void spawnPlayerBullet(double x, double y) {
    world.add(PlayerBullet(
      damage: player.effectiveAtk,
      position: Vector2(x, y),
      bulletType: player.activeBulletType,
      color: player.activeBulletColor,
    ));
  }

  void spawnPlayerBulletWithVelocity(double x, double y, {double speedX = 0}) {
    world.add(PlayerBullet(
      damage: player.effectiveAtk,
      position: Vector2(x, y),
      bulletType: player.activeBulletType,
      color: player.activeBulletColor,
      speedX: speedX,
    ));
  }

  void spawnEnemyBullet(double x, double y, int damage, {double? speedX, double? speedY}) {
    world.add(EnemyBullet(
      damage: damage,
      position: Vector2(x, y),
      speedX: speedX ?? 0,
      speedY: speedY ?? enemyBulletSpeed,
    ));
  }

  void spawnEnemyBulletHoming(double x, double y, int damage, {double? speedX, double? speedY}) {
    world.add(EnemyBullet(
      damage: damage,
      position: Vector2(x, y),
      speedX: speedX ?? 0,
      speedY: speedY ?? enemyBulletSpeed,
      isHoming: true,
    ));
  }

  int _scoreForEnemy(EnemyType type) {
    switch (type) {
      case EnemyType.rush:
        return rushKillScore;
      case EnemyType.swarm:
        return swarmKillScore;
      case EnemyType.phalanx:
        return phalanxKillScore;
      case EnemyType.juggernaut:
        return juggernautKillScore;
      case EnemyType.dodger:
        return dodgerKillScore;
      case EnemyType.splitter:
        return splitterKillScore;
      case EnemyType.summoner:
        return summonerKillScore;
      case EnemyType.sentinel:
        return sentinelKillScore;
      case EnemyType.carrier:
        return carrierKillScore;
      default:
        return enemyKillScore;
    }
  }

  int _creditForEnemy(EnemyType type) {
    switch (type) {
      case EnemyType.stationary:
        return creditPerStationary;
      case EnemyType.patrol:
        return creditPerPatrol;
      case EnemyType.rush:
        return creditPerRush;
      case EnemyType.swarm:
        return creditPerSwarm;
      case EnemyType.phalanx:
        return creditPerPhalanx;
      case EnemyType.juggernaut:
        return creditPerJuggernaut;
      case EnemyType.dodger:
        return creditPerDodger;
      case EnemyType.splitter:
        return creditPerSplitter;
      case EnemyType.summoner:
        return creditPerSummoner;
      case EnemyType.sentinel:
        return creditPerSentinel;
      case EnemyType.carrier:
        return creditPerCarrier;
    }
  }

  void onEnemyKilled(Enemy enemy) {
    enemiesKilled++;
    int killScore = _scoreForEnemy(enemy.type);
    if (isInBoostLane) {
      killScore = (killScore * boostLaneScoreMultiplier).toInt();
    }
    score += killScore;
    creditsEarned += _creditForEnemy(enemy.type);
    spawnKillParticles(
      (p) => world.add(p),
      enemy.position.x,
      enemy.position.y,
      enemy.colorForType,
    );
    _spawnScorePopup(killScore, enemy.position.x, enemy.position.y);
    triggerShake(shakeEnemyKillIntensity, shakeEnemyKillDuration);

    // EX gauge
    addExGauge(exGainOnEnemyKill);

    // Transform gauge
    addTransformGauge(transformGainOnEnemyKill);

    // Form XP
    final isStrong = enemy.type == EnemyType.phalanx ||
        enemy.type == EnemyType.juggernaut ||
        enemy.type == EnemyType.sentinel ||
        enemy.type == EnemyType.carrier;
    formXpEarned += isStrong ? xpPerStrongEnemyKill : xpPerEnemyKill;

    // Splitter: spawn swarms on death
    if (enemy.type == EnemyType.splitter) {
      for (final offset in splitterSpawnOffsets) {
        world.add(Enemy(
          type: EnemyType.swarm,
          position: Vector2(enemy.position.x + offset, enemy.position.y),
        ));
      }
    }
  }

  // --- Pause ---

  void togglePause() {
    if (state == GameState.playing) {
      state = GameState.paused;
    } else if (state == GameState.paused) {
      state = GameState.playing;
    }
  }

  void triggerShake(double intensity, double duration) {
    if (intensity > _shakeIntensity || _shakeTimer <= 0) {
      _shakeIntensity = intensity;
      _shakeTimer = duration;
    }
  }

  void _updateScreenShake(double dt) {
    if (_shakeTimer > 0) {
      _shakeTimer -= dt;
      final ox = (_shakeRng.nextDouble() * 2 - 1) * _shakeIntensity;
      final oy = (_shakeRng.nextDouble() * 2 - 1) * _shakeIntensity;
      camera.viewfinder.position = Vector2(ox, oy);
    } else {
      camera.viewfinder.position = Vector2.zero();
    }
  }

  void _spawnScorePopup(int points, double x, double y) {
    final color = points >= 150
        ? const Color(0xFFFFD600)
        : const Color(0xFFFFFFFF);
    world.add(ScorePopup(
      text: '+$points',
      color: color,
      position: Vector2(x, y),
    ));
  }

  // --- Input (called from Flutter widget layer) ---

  void handlePanUpdate(Offset globalPosition) {
    if (state != GameState.playing) return;
    final lx = globalPosition.dx / _scale;
    final ly = globalPosition.dy / _scale;
    player.position.x = lx;
    player.position.y = ly;
    player.targetX = null;
    player.targetY = null;
  }

  void handleTapUp(Offset globalPosition) {
    if (state != GameState.playing) return;
    player.targetX = globalPosition.dx / _scale;
    player.targetY = globalPosition.dy / _scale;
  }

  void handleExBurstTap() {
    if (state != GameState.playing) return;
    activateExBurst();
  }
}
