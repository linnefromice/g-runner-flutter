import 'package:flutter/material.dart';

import '../g_runner_game.dart';

/// Full-screen pause overlay with Resume and Exit buttons
class PauseOverlay extends StatelessWidget {
  final GRunnerGame game;
  final VoidCallback onExit;

  const PauseOverlay({super.key, required this.game, required this.onExit});

  @override
  Widget build(BuildContext context) {
    if (game.state != GameState.paused) return const SizedBox.shrink();

    return Container(
      color: const Color(0xAA000000),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'PAUSED',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 32),
            _buildButton('RESUME', const Color(0xFF00CCFF), () {
              game.togglePause();
            }),
            const SizedBox(height: 16),
            _buildButton('EXIT', const Color(0xFFFF4444), onExit),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
