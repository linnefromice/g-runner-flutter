import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/data/stage_data.dart';
import '../game/g_runner_game.dart';
import '../game/ui/hud.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GRunnerGame _game;

  @override
  void initState() {
    super.initState();
    _game = GRunnerGame(stageData: stage1);
    _game.onGameEnd = _onGameEnd;
  }

  void _onGameEnd(GameState state, int score) {
    if (!mounted) return;
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            isVictory: state == GameState.stageClear,
            score: score,
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
        ],
      ),
    );
  }
}
