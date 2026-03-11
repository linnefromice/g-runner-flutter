import 'package:flutter/material.dart';

import '../data/game_progress.dart';
import '../game/data/constants.dart';
import '../game/data/stage_data.dart';
import 'game_screen.dart';

class FormSelectScreen extends StatefulWidget {
  final StageData? stageData;
  final bool isEndless;

  const FormSelectScreen({super.key, this.stageData, this.isEndless = false});

  @override
  State<FormSelectScreen> createState() => _FormSelectScreenState();
}

class _FormSelectScreenState extends State<FormSelectScreen> {
  FormType _primary = FormType.standard;
  FormType _secondary = FormType.heavyArtillery;

  static const _allFormDefs = [
    formStandard,
    formHeavyArtillery,
    formHighSpeed,
    formSniper,
    formScatter,
    formGuardian,
  ];

  bool _isUnlocked(FormType type) {
    // Standard, Heavy, HighSpeed are always unlocked
    if (type == FormType.standard ||
        type == FormType.heavyArtillery ||
        type == FormType.highSpeed) {
      return true;
    }
    return GameProgress.instance.isFormUnlocked(type.name);
  }

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
                    'SELECT FORM',
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

            const SizedBox(height: 8),

            // Primary form selection
            _buildSectionLabel('PRIMARY FORM'),
            const SizedBox(height: 8),
            _buildFormGrid(
              selected: _primary,
              disabled: _secondary,
              onSelect: (f) => setState(() => _primary = f),
            ),

            const SizedBox(height: 24),

            // Secondary form selection
            _buildSectionLabel('SECONDARY FORM'),
            const SizedBox(height: 8),
            _buildFormGrid(
              selected: _secondary,
              disabled: _primary,
              onSelect: (f) => setState(() => _secondary = f),
            ),

            const Spacer(),

            // Start button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GameScreen(
                          stageData: widget.stageData,
                          primaryForm: _primary,
                          secondaryForm: _secondary,
                          isEndless: widget.isEndless,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00CCFF),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'START',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildFormGrid({
    required FormType selected,
    required FormType disabled,
    required void Function(FormType) onSelect,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _allFormDefs.map((form) {
          final isSelected = form.type == selected;
          final isDisabled = form.type == disabled;
          final isLocked = !_isUnlocked(form.type);
          return SizedBox(
            width: 96,
            child: _FormCard(
              form: form,
              isSelected: isSelected,
              isDisabled: isDisabled || isLocked,
              isLocked: isLocked,
              onTap: (isDisabled || isLocked) ? null : () => onSelect(form.type),
              onUnlock: isLocked ? () => _tryUnlock(form.type) : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  void _tryUnlock(FormType type) {
    final progress = GameProgress.instance;
    if (progress.canUnlockForm(type)) {
      setState(() {
        progress.purchaseFormUnlock(type);
        progress.save();
      });
    }
  }
}

class _FormCard extends StatelessWidget {
  final FormDefinition form;
  final bool isSelected;
  final bool isDisabled;
  final bool isLocked;
  final VoidCallback? onTap;
  final VoidCallback? onUnlock;

  const _FormCard({
    required this.form,
    required this.isSelected,
    required this.isDisabled,
    this.isLocked = false,
    this.onTap,
    this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? form.bulletColor
        : isDisabled
            ? const Color(0xFF333333)
            : const Color(0xFF555555);

    return GestureDetector(
      onTap: isLocked ? onUnlock : onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? form.bulletColor.withValues(alpha: 0.1)
              : const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              form.name,
              style: TextStyle(
                color: isLocked ? Colors.white24 : isDisabled ? Colors.white24 : Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            if (isLocked) ...[
              const Icon(Icons.lock, color: Colors.white24, size: 16),
              const SizedBox(height: 2),
              Text(
                _unlockLabel(form.type),
                style: const TextStyle(color: Colors.white24, fontSize: 8),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              _statRow('ATK', '${(form.atkMultiplier * 100).toInt()}%', isDisabled),
              _statRow('SPD', '${(form.speedMultiplier * 100).toInt()}%', isDisabled),
              _statRow('FIRE', '${(form.fireRateMultiplier * 100).toInt()}%', isDisabled),
            ],
          ],
        ),
      ),
    );
  }

  String _unlockLabel(FormType type) {
    final cond = formUnlockConditions[type];
    if (cond == null) return '';
    return 'S${cond.requiredStage} + ${cond.cost}Cr';
  }

  Widget _statRow(String label, String value, bool dim) {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: dim ? Colors.white24 : Colors.white54,
              fontSize: 9,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: dim ? Colors.white24 : Colors.white70,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
