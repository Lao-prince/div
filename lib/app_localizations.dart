import 'package:flutter/foundation.dart';

class AppLocalizations {
  static const String _storageKey = 'app_language';
  static bool _isRussian = false;
  static final ValueNotifier<bool> languageNotifier = ValueNotifier<bool>(false);

  static bool get isRussian => _isRussian;
  static set isRussian(bool value) {
    _isRussian = value;
    languageNotifier.value = value;
  }

  static String get gameTitle => 'DIV GAME';
  static String get score => _isRussian ? 'СЧЁТ' : 'SCORE';
  static String get best => _isRussian ? 'РЕКОРД' : 'BEST';
  static String get history => _isRussian ? 'ИСТОРИЯ' : 'HISTORY';
  static String get playAgain => _isRussian ? 'ИГРАТЬ СНОВА' : 'PLAY AGAIN';
  static String get settings => _isRussian ? 'НАСТРОЙКИ' : 'SETTINGS';
  static String get gameOver => _isRussian ? 'ИГРА ОКОНЧЕНА' : 'GAME OVER';
  static String get finalScore => _isRussian ? 'Итоговый счёт' : 'Final Score';
  static String get newRecord => _isRussian ? 'НОВЫЙ РЕКОРД!' : 'NEW RECORD!';
  static String get gameMode => _isRussian ? 'Режим игры' : 'Game Mode';
  static String get dragAndDropMode => _isRussian ? 'Режим перетаскивания' : 'Drag & Drop Mode';
  static String get tapMode => _isRussian ? 'Режим нажатия' : 'Tap Mode';
  static String get language => _isRussian ? 'Язык' : 'Language';
  static String get russian => _isRussian ? 'Русский' : 'Russian';
  static String get english => _isRussian ? 'Английский' : 'English';
  static String get date => _isRussian ? 'Дата' : 'Date';
  static String get startGame => _isRussian ? 'НАЧАТЬ ИГРУ' : 'START GAME';

  // Строки для окна How to Play
  static String get howToPlay => _isRussian ? 'Как играть' : 'How to Play';
  static String get gameRules => _isRussian ? 'Правила игры:' : 'Game Rules:';
  static String get example => _isRussian ? 'Пример:' : 'Example:';
  static String get gameModes => _isRussian ? 'Режимы игры:' : 'Game Modes:';
  static String get watchAgain => _isRussian ? 'Смотреть снова' : 'Watch Again';
  
  // Правила игры
  static String get rule1 => _isRussian 
      ? '1. Размещайте числа на сетке, взаимодействуя с соседними ячейками'
      : '1. Place numbers on the grid, interacting with adjacent cells';
  static String get rule2 => _isRussian 
      ? '2. Если соседние числа имеют общий делитель больше 1, они взаимодействуют'
      : '2. If adjacent numbers have a common divisor greater than 1, they interact';
  static String get rule3 => _isRussian 
      ? '3. При взаимодействии числа делятся на их наибольший общий делитель'
      : '3. During interaction, numbers are divided by their greatest common divisor';
  static String get rule4 => _isRussian 
      ? '4. Если результат деления равен 1, ячейка очищается'
      : '4. If the division result equals 1, the cell is cleared';
  static String get rule5 => _isRussian 
      ? '5. За каждое взаимодействие начисляются очки'
      : '5. Points are awarded for each interaction';
  static String get rule6 => _isRussian 
      ? '6. Последовательные взаимодействия создают комбо (до x5)'
      : '6. Consecutive interactions create combos (up to x5)';
  static String get rule7 => _isRussian 
      ? '7. Игра заканчивается, когда сетка заполнена и взаимодействия невозможны'
      : '7. Game ends when the grid is full and no interactions are possible';
  
  // Строки для анимированного примера
  static String get placeFirstNumber => _isRussian ? 'Разместите первое число' : 'Place first number';
  static String get placeSecondNumber => _isRussian ? 'Разместите второе число' : 'Place second number';
  static String get divisionExplanation => _isRussian 
      ? 'Оба числа делятся на 4'
      : 'Both numbers can be divided by 4';
  static String get resultAfterDivision => _isRussian 
      ? 'Результат после деления'
      : 'Result after division';
  
  // Описание режимов
  static String get tapModeDescription => _isRussian 
      ? '• Режим нажатия: выберите ячейку для размещения числа'
      : '• Tap Mode: select a cell to place a number';
  static String get dragDropModeDescription => _isRussian 
      ? '• Режим перетаскивания: перетащите число в нужную ячейку'
      : '• Drag & Drop Mode: drag the number to the desired cell';
} 