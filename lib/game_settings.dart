import 'package:shared_preferences/shared_preferences.dart';

enum GameMode {
  dragAndDrop,
  tap
}

class GameSettings {
  static const String _gameModeKey = 'game_mode';
  
  static GameMode _gameMode = GameMode.dragAndDrop;
  
  static GameMode get gameMode => _gameMode;
  
  static set gameMode(GameMode mode) {
    _gameMode = mode;
    _saveSettings();
  }

  static Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_gameModeKey, _gameMode.toString());
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
  }
}
