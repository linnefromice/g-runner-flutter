import 'package:flutter/material.dart';

import 'achievements_screen.dart';
import 'form_select_screen.dart';
import 'how_to_play_screen.dart';
import 'settings_screen.dart';
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
            const SizedBox(height: 12),
            _MenuButton(
              label: 'ENDLESS',
              color: const Color(0xFFFF8844),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const FormSelectScreen(isEndless: true),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _MenuButton(
              label: 'ACHIEVEMENTS',
              color: const Color(0xFFFFD600),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const AchievementsScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SmallMenuButton(
                  label: 'SETTINGS',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
                const SizedBox(width: 12),
                _SmallMenuButton(
                  label: 'HOW TO PLAY',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const HowToPlayScreen()),
                    );
                  },
                ),
              ],
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
  final Color color;

  const _MenuButton({
    required this.label,
    required this.onPressed,
    this.color = const Color(0xFF00CCFF),
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 4,
        ),
      ),
    );
  }
}

class _SmallMenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _SmallMenuButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0x88FFFFFF), width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
