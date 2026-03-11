// Lightweight i18n: EN/JP translation dictionary

const Map<String, Map<String, String>> _translations = {
  // Title screen
  'title.game_name': {'en': 'G-RUNNER', 'ja': 'G-RUNNER'},
  'title.subtitle': {'en': 'FLUTTER EDITION', 'ja': 'FLUTTER EDITION'},
  'title.start': {'en': 'START', 'ja': 'スタート'},
  'title.endless': {'en': 'ENDLESS', 'ja': 'エンドレス'},
  'title.achievements': {'en': 'ACHIEVEMENTS', 'ja': '実績'},
  'title.settings': {'en': 'SETTINGS', 'ja': '設定'},
  'title.how_to_play': {'en': 'HOW TO PLAY', 'ja': '遊び方'},

  // Stage select
  'stage_select.title': {'en': 'STAGE SELECT', 'ja': 'ステージ選択'},
  'stage_select.locked': {'en': 'LOCKED', 'ja': 'ロック中'},
  'stage_select.best': {'en': 'BEST', 'ja': 'ベスト'},

  // Form select
  'form_select.title': {'en': 'SELECT FORMS', 'ja': 'フォーム選択'},
  'form_select.primary': {'en': 'PRIMARY', 'ja': 'プライマリ'},
  'form_select.secondary': {'en': 'SECONDARY', 'ja': 'セカンダリ'},
  'form_select.launch': {'en': 'LAUNCH', 'ja': '出撃'},

  // Upgrade
  'upgrade.title': {'en': 'UPGRADE', 'ja': 'アップグレード'},
  'upgrade.credit_boost': {'en': 'CREDIT BOOST', 'ja': 'クレジットブースト'},
  'upgrade.credit_boost_desc': {'en': '+10% credits per level', 'ja': 'レベル毎に+10%クレジット'},

  // Result
  'result.stage_clear': {'en': 'STAGE CLEAR', 'ja': 'ステージクリア'},
  'result.game_over': {'en': 'GAME OVER', 'ja': 'ゲームオーバー'},
  'result.score': {'en': 'SCORE', 'ja': 'スコア'},
  'result.bonus': {'en': 'BONUS', 'ja': 'ボーナス'},
  'result.stages': {'en': 'STAGES', 'ja': 'ステージ'},
  'result.upgrade': {'en': 'UPGRADE', 'ja': 'アップグレード'},
  'result.title_screen': {'en': 'TITLE', 'ja': 'タイトル'},

  // Endless
  'endless.title': {'en': 'ENDLESS MODE', 'ja': 'エンドレスモード'},
  'endless.best_score': {'en': 'BEST SCORE', 'ja': 'ベストスコア'},
  'endless.best_time': {'en': 'BEST TIME', 'ja': 'ベストタイム'},
  'endless.wave': {'en': 'WAVE', 'ja': 'ウェーブ'},
  'endless.time': {'en': 'TIME', 'ja': '時間'},

  // Achievements
  'achievements.title': {'en': 'ACHIEVEMENTS', 'ja': '実績'},
  'achievements.claim': {'en': 'CLAIM', 'ja': '受取'},
  'achievements.claimed': {'en': 'CLAIMED', 'ja': '受取済'},
  'achievements.locked': {'en': 'LOCKED', 'ja': '未達成'},

  // Settings
  'settings.title': {'en': 'SETTINGS', 'ja': '設定'},
  'settings.bgm_volume': {'en': 'BGM Volume', 'ja': 'BGM 音量'},
  'settings.se_volume': {'en': 'SE Volume', 'ja': 'SE 音量'},
  'settings.language': {'en': 'Language', 'ja': '言語'},
  'settings.lang_system': {'en': 'System', 'ja': 'システム'},
  'settings.lang_en': {'en': 'English', 'ja': 'English'},
  'settings.lang_ja': {'en': '日本語', 'ja': '日本語'},

  // HUD
  'hud.boss': {'en': 'BOSS', 'ja': 'ボス'},
  'hud.combo': {'en': 'COMBO', 'ja': 'コンボ'},
  'hud.awakened': {'en': 'AWAKENED', 'ja': '覚醒'},
  'hud.graze': {'en': 'GRAZE', 'ja': 'グレイズ'},

  // How to play
  'howto.title': {'en': 'HOW TO PLAY', 'ja': '遊び方'},
  'howto.controls_title': {'en': 'Controls', 'ja': '操作方法'},
  'howto.controls_body': {
    'en': 'Drag or tap to move your ship.\nYour ship fires automatically.',
    'ja': 'ドラッグまたはタップで機体を移動。\n自動で射撃します。',
  },
  'howto.gates_title': {'en': 'Gates', 'ja': 'ゲート'},
  'howto.gates_body': {
    'en': 'Pass through gates to power up.\nEnhance (blue) boosts stats.\nRecovery (green) heals HP.\nTradeoff (yellow) has risk/reward.',
    'ja': 'ゲートを通過してパワーアップ。\n強化（青）はステータス上昇。\n回復（緑）はHP回復。\nトレードオフ（黄）はリスク＆リターン。',
  },
  'howto.combo_title': {'en': 'Combo & Awakening', 'ja': 'コンボ＆覚醒'},
  'howto.combo_body': {
    'en': 'Pass gates to build combo.\n3 combos activates Awakening:\n- 2x ATK, invincible for 10s\n- Golden aura effect',
    'ja': 'ゲート通過でコンボ蓄積。\n3コンボで覚醒発動：\n- 攻撃力2倍、10秒間無敵\n- 金色のオーラ',
  },
  'howto.transform_title': {'en': 'Transform', 'ja': 'トランスフォーム'},
  'howto.transform_body': {
    'en': 'Fill the TF gauge to switch forms.\nEach form has unique stats and bullet type.\nSwitching grants a 5s power buff.',
    'ja': 'TFゲージを溜めてフォーム切替。\n各フォームは独自のステータスと弾種。\n切替時に5秒間のバフ付与。',
  },
  'howto.combat_title': {'en': 'Combat', 'ja': '戦闘'},
  'howto.combat_body': {
    'en': 'Graze: Near-miss enemy bullets for bonus.\nParry: Transform right before getting hit.\nEX Burst: Fill gauge to unleash a beam.',
    'ja': 'グレイズ：敵弾にギリギリ近づいてボーナス。\nパリィ：被弾直前にトランスフォーム。\nEXバースト：ゲージ満タンでビーム発射。',
  },
  'howto.forms_title': {'en': 'Mecha Forms', 'ja': 'メカフォーム'},
  'howto.forms_body': {
    'en': 'Standard: Balanced all-rounder\nHeavy Artillery: High ATK, explosive rounds\nHigh Speed: Fast fire, piercing shots\nSniper: Massive damage, shield-piercing\nScatter: 5-way spread fire\nGuardian: Damage reduction',
    'ja': 'スタンダード：バランス型\nヘビーアーティラリー：高火力、爆発弾\nハイスピード：高速射撃、貫通弾\nスナイパー：高威力、シールド貫通\nスキャッター：5方向拡散\nガーディアン：被ダメ軽減',
  },

  // Forms
  'form.standard': {'en': 'Standard', 'ja': 'スタンダード'},
  'form.heavyArtillery': {'en': 'Heavy Artillery', 'ja': 'ヘビーアーティラリー'},
  'form.highSpeed': {'en': 'High Speed', 'ja': 'ハイスピード'},
  'form.sniper': {'en': 'Sniper', 'ja': 'スナイパー'},
  'form.scatter': {'en': 'Scatter', 'ja': 'スキャッター'},
  'form.guardian': {'en': 'Guardian', 'ja': 'ガーディアン'},

  // Pause
  'pause.title': {'en': 'PAUSED', 'ja': 'ポーズ'},
  'pause.resume': {'en': 'RESUME', 'ja': '再開'},
  'pause.exit': {'en': 'EXIT STAGE', 'ja': 'ステージ退出'},

  // Common
  'common.back': {'en': 'BACK', 'ja': '戻る'},
  'common.max': {'en': 'MAX', 'ja': 'MAX'},
};

String _currentLanguage = 'en';

void setLanguage(String lang) {
  _currentLanguage = lang;
}

String getLanguage() => _currentLanguage;

String tr(String key) {
  final entry = _translations[key];
  if (entry == null) return key;
  return entry[_currentLanguage] ?? entry['en'] ?? key;
}
