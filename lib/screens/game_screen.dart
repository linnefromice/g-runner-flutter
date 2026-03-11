import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../data/game_progress.dart';
import '../game/data/constants.dart';
import '../game/data/stage_data.dart';
import '../game/g_runner_game.dart';
import '../game/ui/hud.dart';
import '../game/ui/pause_overlay.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final StageData stageData;
  final FormType primaryForm;
  final FormType secondaryForm;

  const GameScreen({
    super.key,
    required this.stageData,
    this.primaryForm = FormType.standard,
    this.secondaryForm = FormType.heavyArtillery,
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
    _game = GRunnerGame(stageData: widget.stageData);
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

    // Calculate credits earned
    _creditsEarned = _game.creditsEarned;

    // Persist progress
    final progress = GameProgress.instance;
    progress.credits += _creditsEarned;
    progress.updateHighScore(widget.stageData.id, score);
    if (state == GameState.stageClear) {
      progress.unlockNextStage(widget.stageData.id);
    }
    progress.save();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            isVictory: state == GameState.stageClear,
            score: score,
            stageId: widget.stageData.id,
            creditsEarned: _creditsEarned,
          ),
        ),
      );
    });
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
