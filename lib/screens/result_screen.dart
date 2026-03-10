import 'package:flutter/material.dart';

import 'game_screen.dart';
import 'title_screen.dart';

class ResultScreen extends StatelessWidget {
  final bool isVictory;
  final int score;

  const ResultScreen({
    super.key,
    required this.isVictory,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isVictory ? 'STAGE CLEAR' : 'GAME OVER',
              style: TextStyle(
                color: isVictory ? const Color(0xFF44FF88) : const Color(0xFFFF4466),
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                shadows: [
                  Shadow(
                    color: isVictory ? const Color(0xFF44FF88) : const Color(0xFFFF4466),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'SCORE',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$score',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            _ResultButton(
              label: 'RETRY',
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const GameScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _ResultButton(
              label: 'TITLE',
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const TitleScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _ResultButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0x88FFFFFF), width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          letterSpacing: 4,
        ),
      ),
    );
  }
}
