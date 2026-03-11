import 'package:flutter/material.dart';

import 'stage_select_screen.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'G-RUNNER',
              style: TextStyle(
                color: Color(0xFF00CCFF),
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
                shadows: [
                  Shadow(color: Color(0xFF00CCFF), blurRadius: 20),
                  Shadow(color: Color(0xFF0066FF), blurRadius: 40),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'FLUTTER EDITION',
              style: TextStyle(
                color: Color(0x88FFFFFF),
                fontSize: 14,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 60),
            _MenuButton(
              label: 'START',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const StageSelectScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _MenuButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF00CCFF), width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF00CCFF),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 4,
        ),
      ),
    );
  }
}
