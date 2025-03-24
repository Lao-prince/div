import 'package:shared_preferences/shared_preferences.dart';
import 'app_localizations.dart';

enum GameMode {
  dragAndDrop,
  tap
}

class GameSettings {
  static const String _gameModeKey = 'game_mode';
  static const String _languageKey = 'app_language';
  
  static GameMode _gameMode = GameMode.dragAndDrop;
  
  static GameMode get gameMode => _gameMode;
  
  static set gameMode(GameMode mode) {
    _gameMode = mode;
    _saveSettings();
  }

  static Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_gameModeKey, _gameMode == GameMode.dragAndDrop ? 'dragAndDrop' : 'tap');
  }

  static Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Загрузка режима игры
    final savedMode = prefs.getString(_gameModeKey);
    if (savedMode != null) {
      _gameMode = savedMode == 'dragAndDrop' ? GameMode.dragAndDrop : GameMode.tap;
    }

    // Загрузка языка
    final isRussian = prefs.getBool(_languageKey) ?? false;
    AppLocalizations.isRussian = isRussian;
  }

  static Future<void> setLanguage(bool isRussian) async {
    AppLocalizations.isRussian = isRussian;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_languageKey, isRussian);
  }
}
