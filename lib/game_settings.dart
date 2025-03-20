import 'package:shared_preferences/shared_preferences.dart';

enum GameMode {
  dragAndDrop,
  tap
}

class GameSettings {
  static const String _gameModeKey = 'game_mode';
  static const String _musicEnabledKey = 'music_enabled';

  static GameMode _gameMode = GameMode.dragAndDrop;
  static bool _isMusicEnabled = true;

  static GameMode get gameMode => _gameMode;
  static bool get isMusicEnabled => _isMusicEnabled;

  static set gameMode(GameMode mode) {
    _gameMode = mode;
    _saveSettings();
  }

  static set isMusicEnabled(bool value) {
    _isMusicEnabled = value;
    _saveSettings();
  }

  static Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_gameModeKey, _gameMode.toString());
    await prefs.setBool(_musicEnabledKey, _isMusicEnabled);
  }

  static Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final gameModeStr = prefs.getString(_gameModeKey);
    if (gameModeStr != null) {
      _gameMode = GameMode.values.firstWhere(
        (e) => e.toString() == gameModeStr,
        orElse: () => GameMode.dragAndDrop,
      );
    }
    _isMusicEnabled = prefs.getBool(_musicEnabledKey) ?? true;
  }
}
