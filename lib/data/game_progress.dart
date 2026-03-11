import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../game/data/constants.dart';

class UpgradeLevels {
  int atk;
  int hp;
  int speed;
  int def;

  UpgradeLevels({this.atk = 0, this.hp = 0, this.speed = 0, this.def = 0});

  Map<String, dynamic> toJson() => {
        'atk': atk,
        'hp': hp,
        'speed': speed,
        'def': def,
      };

  factory UpgradeLevels.fromJson(Map<String, dynamic> json) => UpgradeLevels(
        atk: json['atk'] as int? ?? 0,
        hp: json['hp'] as int? ?? 0,
        speed: json['speed'] as int? ?? 0,
        def: json['def'] as int? ?? 0,
      );
}

class GameProgress {
  static GameProgress? _instance;
  static GameProgress get instance => _instance!;

  List<int> unlockedStages;
  Map<int, int> highScores;
  int credits;
  List<String> unlockedForms;
  UpgradeLevels upgrades;

  GameProgress._({
    required this.unlockedStages,
    required this.highScores,
    required this.credits,
    required this.unlockedForms,
    required this.upgrades,
  });

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('game_progress');
    if (json != null) {
      final data = jsonDecode(json) as Map<String, dynamic>;
      _instance = GameProgress._(
        unlockedStages: (data['unlockedStages'] as List?)?.cast<int>() ?? [1],
        highScores: (data['highScores'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(int.parse(k), v as int),
            ) ??
            {},
        credits: data['credits'] as int? ?? 0,
        unlockedForms:
            (data['unlockedForms'] as List?)?.cast<String>() ?? ['standard'],
        upgrades: data['upgrades'] != null
            ? UpgradeLevels.fromJson(data['upgrades'] as Map<String, dynamic>)
            : UpgradeLevels(),
      );
    } else {
      _instance = GameProgress._(
        unlockedStages: [1],
        highScores: {},
        credits: 0,
        unlockedForms: ['standard', 'heavyArtillery', 'highSpeed'],
        upgrades: UpgradeLevels(),
      );
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'unlockedStages': unlockedStages,
      'highScores':
          highScores.map((k, v) => MapEntry(k.toString(), v)),
      'credits': credits,
      'unlockedForms': unlockedForms,
      'upgrades': upgrades.toJson(),
    };
    await prefs.setString('game_progress', jsonEncode(data));
  }

  bool isStageUnlocked(int stageId) => unlockedStages.contains(stageId);

  void unlockNextStage(int clearedStageId) {
    final next = clearedStageId + 1;
    if (next <= 10 && !unlockedStages.contains(next)) {
      unlockedStages.add(next);
    }
  }

  bool isFormUnlocked(String formKey) => unlockedForms.contains(formKey);

  bool canUnlockForm(FormType type) {
    final condition = formUnlockConditions[type];
    if (condition == null) return false;
    return unlockedStages.contains(condition.requiredStage) &&
        credits >= condition.cost;
  }

  void purchaseFormUnlock(FormType type) {
    final condition = formUnlockConditions[type];
    if (condition == null || !canUnlockForm(type)) return;
    credits -= condition.cost;
    final key = type.name;
    if (!unlockedForms.contains(key)) {
      unlockedForms.add(key);
    }
  }

  void updateHighScore(int stageId, int score) {
    final current = highScores[stageId] ?? 0;
    if (score > current) {
      highScores[stageId] = score;
    }
  }

  // Upgrade helpers
  int upgradeCost(String stat) {
    final level = _levelFor(stat);
    final base = stat == 'def' ? defUpgradeCostBase : _baseCostFor(stat);
    return base * (level + 1);
  }

  bool canUpgrade(String stat) {
    return _levelFor(stat) < _maxFor(stat) && credits >= upgradeCost(stat);
  }

  void purchaseUpgrade(String stat) {
    if (!canUpgrade(stat)) return;
    credits -= upgradeCost(stat);
    switch (stat) {
      case 'atk':
        upgrades.atk++;
      case 'hp':
        upgrades.hp++;
      case 'speed':
        upgrades.speed++;
      case 'def':
        upgrades.def++;
    }
  }

  int _levelFor(String stat) {
    switch (stat) {
      case 'atk':
        return upgrades.atk;
      case 'hp':
        return upgrades.hp;
      case 'speed':
        return upgrades.speed;
      case 'def':
        return upgrades.def;
      default:
        return 0;
    }
  }

  int _maxFor(String stat) {
    switch (stat) {
      case 'atk':
        return maxAtkLevel;
      case 'hp':
        return maxHpLevel;
      case 'speed':
        return maxSpeedLevel;
      case 'def':
        return maxDefLevel;
      default:
        return 0;
    }
  }

  int _baseCostFor(String stat) {
    switch (stat) {
      case 'atk':
        return atkUpgradeCostBase;
      case 'hp':
        return hpUpgradeCostBase;
      case 'speed':
        return speedUpgradeCostBase;
      case 'def':
        return defUpgradeCostBase;
      default:
        return 100;
    }
  }

  // Get bonus stats from upgrades
  int get bonusAtk => upgrades.atk * atkUpgradePerLevel;
  int get bonusHp => upgrades.hp * hpUpgradePerLevel;
  double get bonusSpeedMultiplier => 1.0 + upgrades.speed * speedUpgradePerLevel;
  double get bonusDefMultiplier => 1.0 - upgrades.def * defUpgradePerLevel;
}
