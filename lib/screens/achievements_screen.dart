import 'package:flutter/material.dart';

import '../data/game_progress.dart';
import '../game/data/achievements.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
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
                    'ACHIEVEMENTS',
                    style: TextStyle(
                      color: Color(0xFFFFD600),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const Spacer(),
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
            // Achievement list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: allAchievements.length,
                itemBuilder: (context, index) {
                  final achievement = allAchievements[index];
                  final isUnlocked = progress.unlockedAchievements
                      .contains(achievement.id.name);
                  final isClaimed = progress.claimedAchievements
                      .contains(achievement.id.name);

                  return _AchievementCard(
                    achievement: achievement,
                    isUnlocked: isUnlocked,
                    isClaimed: isClaimed,
                    onClaim: isUnlocked && !isClaimed
                        ? () {
                            progress.claimAchievement(
                                achievement.id.name, achievement.reward);
                            progress.save();
                            setState(() {});
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

class _AchievementCard extends StatelessWidget {
  final AchievementDefinition achievement;
  final bool isUnlocked;
  final bool isClaimed;
  final VoidCallback? onClaim;

  const _AchievementCard({
    required this.achievement,
    required this.isUnlocked,
    required this.isClaimed,
    this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor;
    if (isClaimed) {
      borderColor = const Color(0xFF44FF88);
    } else if (isUnlocked) {
      borderColor = const Color(0xFFFFD600);
    } else {
      borderColor = const Color(0xFF333333);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor.withValues(alpha: 0.5), width: 1),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? borderColor.withValues(alpha: 0.2)
                    : const Color(0xFF222233),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                isUnlocked ? Icons.emoji_events : Icons.lock,
                color: isUnlocked ? borderColor : const Color(0xFF555555),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.name,
                    style: TextStyle(
                      color: isUnlocked ? Colors.white : Colors.white38,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    achievement.description,
                    style: TextStyle(
                      color: isUnlocked ? Colors.white54 : Colors.white24,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Reward / Claim
            if (isClaimed)
              const Text(
                'CLAIMED',
                style: TextStyle(
                  color: Color(0xFF44FF88),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              )
            else if (isUnlocked)
              ElevatedButton(
                onPressed: onClaim,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD600),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.monetization_on, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '+${achievement.reward}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.monetization_on,
                      color: Color(0xFF555555), size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '${achievement.reward}',
                    style: const TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 12,
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
}
