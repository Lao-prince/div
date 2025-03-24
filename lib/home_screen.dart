import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'game_settings.dart';
import 'app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    GameSettings.loadSettings();
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          return ValueListenableBuilder<bool>(
            valueListenable: AppLocalizations.languageNotifier,
            builder: (context, _, __) {
              return AlertDialog(
                titlePadding: const EdgeInsets.fromLTRB(24, 24, 8, 0),
                contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.settings,
                      style: const TextStyle(
                        color: Color(0xFF776E65),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF776E65),
                        size: 24,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 24,
                    ),
                  ],
                ),
                content: Container(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Блок режима игры
                      Text(
                        AppLocalizations.gameMode,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF776E65),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            GameSettings.gameMode == GameMode.dragAndDrop 
                                ? AppLocalizations.dragAndDropMode 
                                : AppLocalizations.tapMode,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF776E65),
                            ),
                          ),
                          Switch(
                            value: GameSettings.gameMode == GameMode.dragAndDrop,
                            onChanged: (value) {
                              setDialogState(() {
                                GameSettings.gameMode = value ? GameMode.dragAndDrop : GameMode.tap;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Блок выбора языка
                      Text(
                        AppLocalizations.language,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF776E65),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.isRussian 
                                ? AppLocalizations.russian 
                                : AppLocalizations.english,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF776E65),
                            ),
                          ),
                          DropdownButton<bool>(
                            value: AppLocalizations.isRussian,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF776E65),
                            ),
                            underline: const SizedBox(),
                            items: [
                              DropdownMenuItem(
                                value: true,
                                child: Text(
                                  AppLocalizations.russian,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF776E65),
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: false,
                                child: Text(
                                  AppLocalizations.english,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF776E65),
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) async {
                              if (value != null) {
                                await GameSettings.setLanguage(value);
                                setDialogState(() {});
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: const [],
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppLocalizations.languageNotifier,
      builder: (context, _, __) {
        return Scaffold(
          body: Stack(
            children: [
              // Фоновый градиент
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFD4E4F7),  // Более насыщенный светло-голубой
                      Color(0xFFF0E5D8),  // Теплый светлый оттенок
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
              // Декоративные элементы
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF8F7A66).withOpacity(0.2),
                        const Color(0xFF8F7A66).withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                left: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF8F7A66).withOpacity(0.2),
                        const Color(0xFF8F7A66).withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
              // Добавляем еще один декоративный элемент
              Positioned(
                top: MediaQuery.of(context).size.height * 0.3,
                left: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF8F7A66).withOpacity(0.15),
                        const Color(0xFF8F7A66).withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
              ),
              // Основной контент
              SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Логотип
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF776E65),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFFF9F6F2), Color(0xFFEEE4DA)],
                              ).createShader(bounds),
                              child: const Text(
                                'DIV',
                                style: TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Text(
                              'GAME',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEEE4DA),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                      // Кнопки
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            // Кнопка START GAME
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const GameScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8F7A66),
                                foregroundColor: const Color(0xFFF9F6F2),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 64,
                                  vertical: 16,
                                ),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              child: Text(
                                AppLocalizations.startGame,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Нижний ряд кнопок
                            Row(
                              children: [
                                // Кнопка настроек (половина ширины)
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: 64,
                                    child: ElevatedButton(
                                      onPressed: _showSettings,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFBBADA0),
                                        foregroundColor: const Color(0xFFF9F6F2),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 0,
                                        ),
                                        minimumSize: const Size(0, 82),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 4,
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          AppLocalizations.settings,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Кнопки с иконками справа
                                Expanded(
                                  child: SizedBox(
                                    height: 64, // Та же высота
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            titlePadding: const EdgeInsets.fromLTRB(24, 24, 8, 0),
                                            title: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  AppLocalizations.howToPlay,
                                                  style: const TextStyle(
                                                    color: Color(0xFF776E65),
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () => Navigator.of(context).pop(),
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Color(0xFF776E65),
                                                    size: 24,
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                  splashRadius: 24,
                                                ),
                                              ],
                                            ),
                                            content: SingleChildScrollView(
                                              child: _buildHowToPlayContent(),
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFBBADA0),
                                        foregroundColor: const Color(0xFFF9F6F2),
                                        minimumSize: const Size(0, 82),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 4,
                                      ),
                                      child: const Icon(
                                        Icons.help_outline,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: SizedBox(
                                    height: 64, // Та же высота
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Здесь будет управление музыкой
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFBBADA0),
                                        foregroundColor: const Color(0xFFF9F6F2),
                                        minimumSize: const Size(0, 82),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 4,
                                      ),
                                      child: const Icon(
                                        Icons.music_note,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExampleCell(String number) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF8F7A66),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedExample() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEEE4DA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: ValueNotifier<bool>(true),
                builder: (context, _, __) {
                  return TweenAnimationBuilder(
                    key: UniqueKey(),
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(seconds: 6),
                    builder: (context, double value, child) {
                      return Column(
                        children: [
                          // Первое число
                          Opacity(
                            opacity: value > 0.1 ? 1 : 0,
                            child: Text(
                              AppLocalizations.placeFirstNumber,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF776E65),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Transform.scale(
                                scale: value > 0.2 ? 1 : 0,
                                child: _buildExampleCell('12'),
                              ),
                              const SizedBox(width: 8),
                              Container(width: 50),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Второе число
                          Opacity(
                            opacity: value > 0.3 ? 1 : 0,
                            child: Text(
                              AppLocalizations.placeSecondNumber,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF776E65),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildExampleCell('12'),
                              const SizedBox(width: 8),
                              Transform.scale(
                                scale: value > 0.4 ? 1 : 0,
                                child: _buildExampleCell('8'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Объяснение деления
                          Opacity(
                            opacity: value > 0.5 ? 1 : 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    AppLocalizations.divisionExplanation,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF776E65),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    '12 ÷ 4 = 3\n8 ÷ 4 = 2',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF776E65),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Результат
                          Opacity(
                            opacity: value > 0.8 ? 1 : 0,
                            child: Text(
                              AppLocalizations.resultAfterDivision,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF776E65),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Transform.scale(
                                scale: value > 0.9 ? 1 : 0,
                                child: _buildExampleCell('3'),
                              ),
                              const SizedBox(width: 8),
                              Transform.scale(
                                scale: value > 0.9 ? 1 : 0,
                                child: _buildExampleCell('2'),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => setState(() {}),
                icon: const Icon(
                  Icons.replay,
                  color: Color(0xFF776E65),
                  size: 16,
                ),
                label: Text(
                  AppLocalizations.watchAgain,
                  style: const TextStyle(
                    color: Color(0xFF776E65),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHowToPlayContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.gameRules,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF776E65),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${AppLocalizations.rule1}\n'
          '${AppLocalizations.rule2}\n'
          '${AppLocalizations.rule3}\n'
          '${AppLocalizations.rule4}\n'
          '${AppLocalizations.rule5}\n'
          '${AppLocalizations.rule6}\n'
          '${AppLocalizations.rule7}',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF776E65),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.example,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF776E65),
          ),
        ),
        const SizedBox(height: 8),
        _buildAnimatedExample(),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.gameModes,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF776E65),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${AppLocalizations.tapModeDescription}\n'
          '${AppLocalizations.dragDropModeDescription}',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF776E65),
          ),
        ),
      ],
    );
  }
}
