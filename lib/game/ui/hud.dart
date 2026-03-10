import 'dart:async';

import 'package:flutter/material.dart';

import '../g_runner_game.dart';

/// HUD overlay displaying HP and score, updates ~10 times/sec
class HudOverlay extends StatefulWidget {
  final GRunnerGame game;

  const HudOverlay({super.key, required this.game});

  @override
  State<HudOverlay> createState() => _HudOverlayState();
}

class _HudOverlayState extends State<HudOverlay> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    // Wait until player is loaded
    if (game.state == GameState.playing && !game.isLoaded) {
      return const SizedBox.shrink();
    }

    final progress = game.stageData.duration > 0
        ? (game.stageTime / game.stageData.duration).clamp(0.0, 1.0)
        : 0.0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Stage progress bar
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: progress,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF00CCFF),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    color: Color(0xFF00CCFF),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // HP + Score row
            Row(
              children: [
                // HP bar
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HP ${game.player.hp}/${game.player.maxHp}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          widthFactor:
                              (game.player.hp / game.player.maxHp).clamp(0.0, 1.0),
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _hpColor(game.player.hp, game.player.maxHp),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Score
                Text(
                  'SCORE ${game.score}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _hpColor(int hp, int maxHp) {
    final ratio = hp / maxHp;
    if (ratio > 0.5) return Colors.greenAccent;
    if (ratio > 0.25) return Colors.orangeAccent;
    return Colors.redAccent;
  }
}
