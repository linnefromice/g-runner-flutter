import 'package:flutter/material.dart';

import '../data/game_progress.dart';
import '../game/data/stages.dart';
import '../game/data/stage_data.dart';
import 'form_select_screen.dart';

class StageSelectScreen extends StatelessWidget {
  const StageSelectScreen({super.key});

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
                    'SELECT STAGE',
                    style: TextStyle(
                      color: Color(0xFF00CCFF),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const Spacer(),
                  // Credits display
                  Row(
                    children: [
                      const Icon(Icons.monetization_on,
                          color: Color(0xFFFFD600), size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${progress.credits}',
                        style: const TextStyle(
                          color: Color(0xFFFFD600),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Stage list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: allStages.length,
                itemBuilder: (context, index) {
                  final stage = allStages[index];
                  final unlocked = progress.isStageUnlocked(stage.id);
                  final highScore = progress.highScores[stage.id];
                  return _StageCard(
                    stage: stage,
                    unlocked: unlocked,
                    highScore: highScore,
                    onTap: unlocked
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    FormSelectScreen(stageData: stage),
                              ),
                            );
                          }
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StageCard extends StatelessWidget {
  final StageData stage;
  final bool unlocked;
  final int? highScore;
  final VoidCallback? onTap;

  const _StageCard({
    required this.stage,
    required this.unlocked,
    this.highScore,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: unlocked
                ? const Color(0xFF1A1A2E)
                : const Color(0xFF0D0D1A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: unlocked
                  ? const Color(0xFF00CCFF).withValues(alpha: 0.5)
                  : const Color(0xFF333333),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Stage number
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: unlocked
                      ? const Color(0xFF00CCFF).withValues(alpha: 0.15)
                      : const Color(0xFF222222),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: unlocked
                      ? Text(
                          '${stage.id}',
                          style: const TextStyle(
                            color: Color(0xFF00CCFF),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Icon(Icons.lock, color: Color(0xFF555555)),
                ),
              ),
              const SizedBox(width: 16),
              // Stage info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stage.name,
                      style: TextStyle(
                        color: unlocked ? Colors.white : Colors.white38,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${stage.duration.toInt()}s',
                          style: TextStyle(
                            color: unlocked
                                ? Colors.white54
                                : Colors.white24,
                            fontSize: 12,
                          ),
                        ),
                        if (stage.hasBoss) ...[
                          const SizedBox(width: 8),
                          Text(
                            'BOSS',
                            style: TextStyle(
                              color: unlocked
                                  ? const Color(0xFFFF4466)
                                  : Colors.white24,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // High score
              if (highScore != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'BEST',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '$highScore',
                      style: const TextStyle(
                        color: Color(0xFFFFD600),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
