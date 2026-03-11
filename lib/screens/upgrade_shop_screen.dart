import 'package:flutter/material.dart';

import '../data/game_progress.dart';
import '../game/data/constants.dart';

class UpgradeShopScreen extends StatefulWidget {
  const UpgradeShopScreen({super.key});

  @override
  State<UpgradeShopScreen> createState() => _UpgradeShopScreenState();
}

class _UpgradeShopScreenState extends State<UpgradeShopScreen> {
  final _stats = [
    _StatInfo('atk', 'ATK', '+$atkUpgradePerLevel per level', maxAtkLevel,
        const Color(0xFFFF6644)),
    _StatInfo('hp', 'HP', '+$hpUpgradePerLevel per level', maxHpLevel,
        const Color(0xFF44FF88)),
    _StatInfo('speed', 'SPEED', '+${(speedUpgradePerLevel * 100).toInt()}% per level',
        maxSpeedLevel, const Color(0xFF00CCFF)),
    _StatInfo('def', 'DEF', '+${(defUpgradePerLevel * 100).toInt()}% per level',
        maxDefLevel, const Color(0xFFAA88FF)),
  ];

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
                    'UPGRADE',
                    style: TextStyle(
                      color: Color(0xFF00CCFF),
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
            // Upgrade list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ..._stats.map((stat) {
                    final level = _levelFor(stat.key, progress);
                    final cost = progress.upgradeCost(stat.key);
                    final canBuy = progress.canUpgrade(stat.key);
                    final isMax = level >= stat.maxLevel;

                    return _UpgradeCard(
                      stat: stat,
                      level: level,
                      cost: cost,
                      canBuy: canBuy,
                      isMax: isMax,
                      onBuy: canBuy
                          ? () {
                              progress.purchaseUpgrade(stat.key);
                              progress.save();
                              setState(() {});
                            }
                          : null,
                    );
                  }),
                  // Credit Boost
                  _UpgradeCard(
                    stat: _StatInfo(
                      'creditBoost',
                      'CREDIT BOOST',
                      '+${(creditBoostPerLevel * 100).toInt()}% credits per level',
                      maxCreditBoostLevel,
                      const Color(0xFFFFD600),
                    ),
                    level: progress.creditBoostLevel,
                    cost: progress.creditBoostCost(),
                    canBuy: progress.canUpgradeCreditBoost(),
                    isMax: progress.creditBoostLevel >= maxCreditBoostLevel,
                    onBuy: progress.canUpgradeCreditBoost()
                        ? () {
                            progress.purchaseCreditBoost();
                            progress.save();
                            setState(() {});
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _levelFor(String key, GameProgress progress) {
    switch (key) {
      case 'atk':
        return progress.upgrades.atk;
      case 'hp':
        return progress.upgrades.hp;
      case 'speed':
        return progress.upgrades.speed;
      case 'def':
        return progress.upgrades.def;
      default:
        return 0;
    }
  }
}

class _StatInfo {
  final String key;
  final String label;
  final String description;
  final int maxLevel;
  final Color color;

  const _StatInfo(this.key, this.label, this.description, this.maxLevel, this.color);
}

class _UpgradeCard extends StatelessWidget {
  final _StatInfo stat;
  final int level;
  final int cost;
  final bool canBuy;
  final bool isMax;
  final VoidCallback? onBuy;

  const _UpgradeCard({
    required this.stat,
    required this.level,
    required this.cost,
    required this.canBuy,
    required this.isMax,
    this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: stat.color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  stat.label,
                  style: TextStyle(
                    color: stat.color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  stat.description,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  'Lv.$level/${stat.maxLevel}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Level bar
            Row(
              children: List.generate(stat.maxLevel, (i) {
                return Expanded(
                  child: Container(
                    height: 6,
                    margin: const EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      color: i < level
                          ? stat.color
                          : const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            // Buy button
            Align(
              alignment: Alignment.centerRight,
              child: isMax
                  ? const Text(
                      'MAX',
                      style: TextStyle(
                        color: Color(0xFFFFD600),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: onBuy,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canBuy
                            ? const Color(0xFFFFD600)
                            : const Color(0xFF333333),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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
                            '$cost',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
