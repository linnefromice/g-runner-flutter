import 'dart:async';

import 'package:flutter/material.dart';

import '../components/boss.dart';
import '../data/constants.dart';
import '../g_runner_game.dart';

/// HUD overlay displaying HP, score, combo, awakening, and EX gauge
class HudOverlay extends StatefulWidget {
  final GRunnerGame game;

  const HudOverlay({super.key, required this.game});

  @override
  State<HudOverlay> createState() => _HudOverlayState();
}

class _HudOverlayState extends State<HudOverlay> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    if (game.state == GameState.playing && !game.isLoaded) {
      return const SizedBox.shrink();
    }

    final progress = game.stageData.duration > 0
        ? (game.stageTime / game.stageData.duration).clamp(0.0, 1.0)
        : 0.0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Boss HP bar (shown during boss phase)
            if (game.isBossPhase && game.currentBoss != null) ...[
              _buildBossHpBar(game),
              const SizedBox(height: 6),
            ],
            // Stage progress bar + pause button
            Row(
              children: [
                Expanded(child: _buildProgressBar(progress)),
                const SizedBox(width: 8),
                _buildPauseButton(game),
              ],
            ),
            const SizedBox(height: 6),
            // HP + Score row
            _buildHpScoreRow(game),
            const SizedBox(height: 4),
            // Combo + EX row
            _buildComboExRow(game),
            const SizedBox(height: 4),
            // Form + Transform row
            _buildFormTransformRow(game),
            // Awakening timer (shown only when awakened)
            if (game.isAwakened) ...[
              const SizedBox(height: 4),
              _buildAwakenedBar(game),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              widthFactor: progress,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF00CCFF),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(progress * 100).toInt()}%',
          style: const TextStyle(
            color: Color(0xFF00CCFF),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  Widget _buildHpScoreRow(GRunnerGame game) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HP ${game.player.hp}/${game.player.maxHp}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  widthFactor: (game.player.hp / game.player.maxHp).clamp(0.0, 1.0),
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _hpColor(game.player.hp, game.player.maxHp),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'SCORE ${game.score}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildComboExRow(GRunnerGame game) {
    return Row(
      children: [
        // Combo gauge (3 segments)
        _buildComboGauge(game.comboCount),
        const SizedBox(width: 12),
        // EX gauge bar
        Expanded(child: _buildExGauge(game)),
        // EX Burst button
        if (game.exGauge >= exGaugeMax)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: GestureDetector(
              onTap: () => game.handleExBurstTap(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEA00),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'EX',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildComboGauge(int comboCount) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'COMBO ',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        for (int i = 0; i < comboThreshold; i++)
          Container(
            width: 12,
            height: 8,
            margin: const EdgeInsets.only(right: 2),
            decoration: BoxDecoration(
              color: i < comboCount
                  ? const Color(0xFFFFEA00)
                  : const Color(0xFF333333),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }

  Widget _buildExGauge(GRunnerGame game) {
    final ratio = (game.exGauge / exGaugeMax).clamp(0.0, 1.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EX',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 1),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFF333333),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            widthFactor: ratio,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: ratio >= 1.0
                    ? const Color(0xFFFFEA00)
                    : const Color(0xFFFF8800),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAwakenedBar(GRunnerGame game) {
    final ratio = (game.awakenedTimer / awakenedDuration).clamp(0.0, 1.0);
    final isWarning = game.awakenedWarning;
    return Row(
      children: [
        Text(
          'AWAKENED',
          style: TextStyle(
            color: isWarning ? const Color(0xFFFF4444) : const Color(0xFFFFEA00),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              widthFactor: ratio,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: isWarning
                      ? const Color(0xFFFF4444)
                      : const Color(0xFFFFEA00),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormTransformRow(GRunnerGame game) {
    final tfRatio = (game.transformGauge / transformGaugeMax).clamp(0.0, 1.0);
    final formName = game.player.currentForm.name;
    return Row(
      children: [
        // Current form label
        Text(
          formName,
          style: TextStyle(
            color: game.player.currentForm.bulletColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        // Transform gauge
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              widthFactor: tfRatio,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: tfRatio >= 1.0
                      ? const Color(0xFF44FFAA)
                      : const Color(0xFF228866),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
        // TF button
        if (game.transformGauge >= transformGaugeMax && !game.isAwakened)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: GestureDetector(
              onTap: () => game.handleTransformTap(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF44FFAA),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'TF',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBossHpBar(GRunnerGame game) {
    final boss = game.currentBoss!;
    final ratio = boss.hpRatio.clamp(0.0, 1.0);

    final Color barColor;
    switch (boss.phase) {
      case BossPhase.entering:
      case BossPhase.phase1:
        barColor = const Color(0xFF8844FF); // Purple
      case BossPhase.phase2:
        barColor = const Color(0xFFFF6644); // Orange-red
      case BossPhase.phase3:
        barColor = const Color(0xFFFF2244); // Red
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'BOSS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${boss.hp}/${boss.maxHp}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: barColor.withValues(alpha: 0.5), width: 1),
          ),
          child: FractionallySizedBox(
            widthFactor: ratio,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPauseButton(GRunnerGame game) {
    return GestureDetector(
      onTap: () => game.togglePause(),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: const Color(0x44FFFFFF),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Center(
          child: Text(
            '||',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _hpColor(int hp, int maxHp) {
    final ratio = hp / maxHp;
    if (ratio > 0.5) return Colors.greenAccent;
    if (ratio > 0.25) return Colors.orangeAccent;
    return Colors.redAccent;
  }
}
