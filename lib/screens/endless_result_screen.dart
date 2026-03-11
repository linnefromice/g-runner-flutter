import 'package:flutter/material.dart';

import 'title_screen.dart';

class EndlessResultScreen extends StatelessWidget {
  final int score;
  final double survivalTime;
  final int waveReached;
  final int creditsEarned;

  const EndlessResultScreen({
    super.key,
    required this.score,
    required this.survivalTime,
    required this.waveReached,
    required this.creditsEarned,
  });

  String _formatTime(double seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds.toInt() % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ENDLESS MODE',
              style: TextStyle(
                color: Color(0xFFFF8844),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                shadows: [
                  Shadow(color: Color(0xFFFF8844), blurRadius: 20),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'GAME OVER',
              style: TextStyle(
                color: Color(0xFFFF4466),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 32),
            // Stats
            _StatRow(label: 'SCORE', value: '$score'),
            const SizedBox(height: 8),
            _StatRow(label: 'TIME', value: _formatTime(survivalTime)),
            const SizedBox(height: 8),
            _StatRow(label: 'WAVE', value: '$waveReached'),
            const SizedBox(height: 16),
            // Credits
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.monetization_on,
                    color: Color(0xFFFFD600), size: 20),
                const SizedBox(width: 6),
                Text(
                  '+$creditsEarned',
                  style: const TextStyle(
                    color: Color(0xFFFFD600),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const TitleScreen()),
                  (route) => false,
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0x88FFFFFF), width: 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              child: const Text(
                'TITLE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
