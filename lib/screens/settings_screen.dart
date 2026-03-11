import 'package:flutter/material.dart';

import '../data/game_progress.dart';
import '../i18n/translations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final progress = GameProgress.instance;

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
                    'SETTINGS',
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
                  // BGM Volume
                  _buildVolumeSlider(
                    label: 'BGM Volume',
                    value: progress.bgmVolume,
                    onChanged: (v) {
                      setState(() => progress.bgmVolume = v);
                      progress.save();
                    },
                  ),
                  const SizedBox(height: 24),
                  // SE Volume
                  _buildVolumeSlider(
                    label: 'SE Volume',
                    value: progress.seVolume,
                    onChanged: (v) {
                      setState(() => progress.seVolume = v);
                      progress.save();
                    },
                  ),
                  const SizedBox(height: 32),
                  // Language
                  const Text(
                    'Language',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildLanguageOption('system', 'System', progress),
                  _buildLanguageOption('en', 'English', progress),
                  _buildLanguageOption('ja', '日本語', progress),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(
                color: Color(0xFF00CCFF),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFF00CCFF),
            inactiveTrackColor: const Color(0xFF333333),
            thumbColor: const Color(0xFF00CCFF),
            overlayColor: const Color(0xFF00CCFF).withValues(alpha: 0.2),
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
            divisions: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageOption(
      String langCode, String label, GameProgress progress) {
    final isSelected = progress.language == langCode;
    return GestureDetector(
      onTap: () {
        setState(() {
          progress.language = langCode;
          if (langCode == 'system') {
            setLanguage('en');
          } else {
            setLanguage(langCode);
          }
        });
        progress.save();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00CCFF).withValues(alpha: 0.15)
              : const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00CCFF)
                : const Color(0xFF333333),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected
                  ? const Color(0xFF00CCFF)
                  : const Color(0xFF555555),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
