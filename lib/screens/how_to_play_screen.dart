import 'package:flutter/material.dart';

import '../i18n/translations.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white70),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'HOW TO PLAY',
                    style: TextStyle(
                      color: Color(0xFF00CCFF),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _Section(
                    title: tr('howto.controls_title'),
                    body: tr('howto.controls_body'),
                    icon: Icons.touch_app,
                  ),
                  _Section(
                    title: tr('howto.gates_title'),
                    body: tr('howto.gates_body'),
                    icon: Icons.door_sliding,
                  ),
                  _Section(
                    title: tr('howto.combo_title'),
                    body: tr('howto.combo_body'),
                    icon: Icons.flash_on,
                  ),
                  _Section(
                    title: tr('howto.transform_title'),
                    body: tr('howto.transform_body'),
                    icon: Icons.transform,
                  ),
                  _Section(
                    title: tr('howto.combat_title'),
                    body: tr('howto.combat_body'),
                    icon: Icons.gps_fixed,
                  ),
                  _Section(
                    title: tr('howto.forms_title'),
                    body: tr('howto.forms_body'),
                    icon: Icons.smart_toy,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;

  const _Section({
    required this.title,
    required this.body,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF00CCFF).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF00CCFF), size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF00CCFF),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              body,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
