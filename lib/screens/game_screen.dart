import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../data/game_progress.dart';
import '../game/data/achievements.dart';
import '../game/data/bonuses.dart';
import '../game/data/constants.dart';
import '../game/data/endless_data.dart';
import '../game/data/stage_data.dart';
import '../game/g_runner_game.dart';
import '../game/ui/hud.dart';
import '../game/ui/pause_overlay.dart';
import 'endless_result_screen.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final StageData? stageData;
  final FormType primaryForm;
  final FormType secondaryForm;
  final bool isEndless;

  const GameScreen({
    super.key,
    this.stageData,
    this.primaryForm = FormType.standard,
    this.secondaryForm = FormType.heavyArtillery,
    this.isEndless = false,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GRunnerGame _game;
  int _creditsEarned = 0;

  @override
  void initState() {
    super.initState();

    StageData effectiveStageData;
    if (widget.isEndless) {
      // Generate initial endless wave
      final rng = Random();
      final initialEvents = generateEndlessWave(0, rng);
      effectiveStageData = StageData(
        id: 0,
        name: 'Endless',
        duration: double.infinity,
        timeline: initialEvents,
      );
    } else {
      effectiveStageData = widget.stageData!;
    }

    _game = GRunnerGame(
      stageData: effectiveStageData,
      isEndless: widget.isEndless,
    );
    _game.primaryForm = widget.primaryForm;
    _game.secondaryForm = widget.secondaryForm;

    // Apply upgrade bonuses
    final progress = GameProgress.instance;
    _game.upgradeBonusAtk = progress.bonusAtk;
    _game.upgradeBonusHp = progress.bonusHp;
    _game.upgradeBonusSpeedMultiplier = progress.bonusSpeedMultiplier;
    _game.upgradeBonusDefMultiplier = progress.bonusDefMultiplier;

    _game.onGameEnd = _onGameEnd;
  }

  void _onGameEnd(GameState state, int score) {
    if (!mounted) return;

    _creditsEarned = _game.creditsEarned;

    final progress = GameProgress.instance;

    // Apply credit boost multiplier
    _creditsEarned = (_creditsEarned * progress.creditBoostMultiplier).toInt();

    if (widget.isEndless) {
      // Endless mode: save best score/time, check achievements, navigate to endless result
      progress.credits += _creditsEarned;
      progress.totalCreditsEarned += _creditsEarned;
      progress.updateEndlessBest(score, _game.stageTime);

      // Persist form XP
      final activeFormKey = _game.currentFormType.name;
      progress.addFormXp(activeFormKey, _game.formXpEarned);

      // Check achievements
      _checkAndApplyAchievements(state, score);

      progress.save();

      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => EndlessResultScreen(
              score: score,
              survivalTime: _game.stageTime,
              waveReached: _game.endlessWave,
              creditsEarned: _creditsEarned,
            ),
          ),
        );
      });
      return;
    }

    // Normal stage mode
    List<BonusResult> bonuses = [];
    int finalScore = score;
    if (state == GameState.stageClear) {
      final input = BonusInput(
        damageTaken: _game.damageTaken,
        awakenedCount: _game.awakenedCount,
        enemiesSpawned: _game.enemiesSpawned,
        enemiesKilled: _game.enemiesKilled,
        isBossStage: widget.stageData!.hasBoss,
        remainingTime: widget.stageData!.duration - _game.stageTime,
      );
      bonuses = calculateBonuses(input);
      finalScore = applyScoreBonus(score, bonuses);
      _creditsEarned = applyCreditBonus(_creditsEarned, bonuses);
    }

    // Persist progress
    progress.credits += _creditsEarned;
    progress.totalCreditsEarned += _creditsEarned;
    progress.updateHighScore(widget.stageData!.id, finalScore);
    if (state == GameState.stageClear) {
      progress.unlockNextStage(widget.stageData!.id);
    }

    // Persist form XP for the active form
    final activeFormKey = _game.currentFormType.name;
    progress.addFormXp(activeFormKey, _game.formXpEarned);

    // Check achievements
    _checkAndApplyAchievements(state, finalScore);

    progress.save();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            isVictory: state == GameState.stageClear,
            score: finalScore,
            stageId: widget.stageData!.id,
            creditsEarned: _creditsEarned,
            bonuses: bonuses,
          ),
        ),
      );
    });
  }

  void _checkAndApplyAchievements(GameState state, int score) {
    final progress = GameProgress.instance;
    final input = AchievementCheckInput(
      stageClear: state == GameState.stageClear,
      bossDefeated: _game.isBossPhase == false &&
          (widget.stageData?.hasBoss ?? false) &&
          state == GameState.stageClear,
      damageTaken: _game.damageTaken,
      awakenedCount: _game.awakenedCount,
      activeForm: _game.currentFormType,
      playerHp: _game.player.hp,
      playerMaxHp: _game.player.maxHp,
      isEndless: widget.isEndless,
      endlessSurvivalTime: _game.stageTime,
    );

    final results = checkAchievements(input, progress);
    for (final result in results) {
      progress.unlockAchievement(result.id.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              _game.handlePanUpdate(details.globalPosition);
            },
            onTapUp: (details) {
              _game.handleTapUp(details.globalPosition);
            },
            child: GameWidget(game: _game),
          ),
          HudOverlay(game: _game),
          PauseOverlay(
            game: _game,
            onExit: () {
              if (!mounted) return;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
