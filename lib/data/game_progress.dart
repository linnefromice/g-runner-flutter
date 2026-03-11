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

  // Form XP and skill tree
  Map<String, int> formXp; // formType.name → cumulative XP
  Map<String, List<String>> formSkills; // formType.name → list of selected skill IDs

  // Achievements
  List<String> unlockedAchievements;
  List<String> claimedAchievements;
  int totalCreditsEarned;

  // Endless mode
  int endlessBestScore;
  double endlessBestTime;

  // Credit Boost
  int creditBoostLevel;

  // Settings
  double bgmVolume;
  double seVolume;
  String language; // 'system', 'en', 'ja'

  GameProgress._({
    required this.unlockedStages,
    required this.highScores,
    required this.credits,
    required this.unlockedForms,
    required this.upgrades,
    required this.formXp,
    required this.formSkills,
    required this.unlockedAchievements,
    required this.claimedAchievements,
    required this.totalCreditsEarned,
    required this.endlessBestScore,
    required this.endlessBestTime,
    required this.creditBoostLevel,
    required this.bgmVolume,
    required this.seVolume,
    required this.language,
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
        formXp: (data['formXp'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, v as int),
            ) ??
            {},
        formSkills: (data['formSkills'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, (v as List).cast<String>()),
            ) ??
            {},
        unlockedAchievements:
            (data['unlockedAchievements'] as List?)?.cast<String>() ?? [],
        claimedAchievements:
            (data['claimedAchievements'] as List?)?.cast<String>() ?? [],
        totalCreditsEarned: data['totalCreditsEarned'] as int? ?? 0,
        endlessBestScore: data['endlessBestScore'] as int? ?? 0,
        endlessBestTime: (data['endlessBestTime'] as num?)?.toDouble() ?? 0,
        creditBoostLevel: data['creditBoostLevel'] as int? ?? 0,
        bgmVolume: (data['bgmVolume'] as num?)?.toDouble() ?? 0.7,
        seVolume: (data['seVolume'] as num?)?.toDouble() ?? 1.0,
        language: data['language'] as String? ?? 'system',
      );
    } else {
      _instance = GameProgress._(
        unlockedStages: [1],
        highScores: {},
        credits: 0,
        unlockedForms: ['standard', 'heavyArtillery', 'highSpeed'],
        upgrades: UpgradeLevels(),
        formXp: {},
        formSkills: {},
        unlockedAchievements: [],
        claimedAchievements: [],
        totalCreditsEarned: 0,
        endlessBestScore: 0,
        endlessBestTime: 0,
        creditBoostLevel: 0,
        bgmVolume: 0.7,
        seVolume: 1.0,
        language: 'system',
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
      'formXp': formXp,
      'formSkills': formSkills,
      'unlockedAchievements': unlockedAchievements,
      'claimedAchievements': claimedAchievements,
      'totalCreditsEarned': totalCreditsEarned,
      'endlessBestScore': endlessBestScore,
      'endlessBestTime': endlessBestTime,
      'creditBoostLevel': creditBoostLevel,
      'bgmVolume': bgmVolume,
      'seVolume': seVolume,
      'language': language,
    };
    await prefs.setString('game_progress', jsonEncode(data));
  }

  bool isStageUnlocked(int stageId) => unlockedStages.contains(stageId);

  void unlockNextStage(int clearedStageId) {
    final next = clearedStageId + 1;
    if (next <= 15 && !unlockedStages.contains(next)) {
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

  int getFormXp(String formKey) => formXp[formKey] ?? 0;

  void addFormXp(String formKey, int amount) {
    formXp[formKey] = (formXp[formKey] ?? 0) + amount;
  }

  List<String> getFormSkills(String formKey) => formSkills[formKey] ?? [];

  void selectFormSkill(String formKey, String skillId) {
    formSkills[formKey] = [...getFormSkills(formKey), skillId];
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

  // Credit Boost
  double get creditBoostMultiplier => 1.0 + creditBoostLevel * creditBoostPerLevel;

  int creditBoostCost() => creditBoostCostBase * (creditBoostLevel + 1);

  bool canUpgradeCreditBoost() =>
      creditBoostLevel < maxCreditBoostLevel && credits >= creditBoostCost();

  void purchaseCreditBoost() {
    if (!canUpgradeCreditBoost()) return;
    credits -= creditBoostCost();
    creditBoostLevel++;
  }

  // Achievement helpers
  void unlockAchievement(String id) {
    if (!unlockedAchievements.contains(id)) {
      unlockedAchievements.add(id);
    }
  }

  bool isAchievementClaimed(String id) => claimedAchievements.contains(id);

  void claimAchievement(String id, int reward) {
    if (!claimedAchievements.contains(id)) {
      claimedAchievements.add(id);
      credits += reward;
    }
  }

  // Endless mode helpers
  void updateEndlessBest(int score, double time) {
    if (score > endlessBestScore) endlessBestScore = score;
    if (time > endlessBestTime) endlessBestTime = time;
  }
}
