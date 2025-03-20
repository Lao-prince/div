import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'game_settings.dart';

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

  void _toggleMusic() {
    setState(() {
      GameSettings.isMusicEnabled = !GameSettings.isMusicEnabled;
      // TODO: Добавить логику включения/выключения музыки
    });
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Настройки',
          style: TextStyle(
            color: Color(0xFF776E65),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Режим игры'),
              subtitle: DropdownButton<GameMode>(
                value: GameSettings.gameMode,
                items: const [
                  DropdownMenuItem(
                    value: GameMode.dragAndDrop,
                    child: Text('Перетаскивание'),
                  ),
                  DropdownMenuItem(
                    value: GameMode.tap,
                    child: Text('Нажатие'),
                  ),
                ],
                onChanged: (GameMode? newValue) {
                  if (newValue != null) {
                    setState(() {
                      GameSettings.gameMode = newValue;
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Музыка'),
              trailing: Switch(
                value: GameSettings.isMusicEnabled,
                onChanged: (value) {
                  Navigator.pop(context);
                  _toggleMusic();
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Закрыть',
              style: TextStyle(
                color: Color(0xFF776E65),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8EF),
      body: SafeArea(
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
                child: const Column(
                  children: [
                    Text(
                      'GCD',
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF9F6F2),
                      ),
                    ),
                    Text(
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
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      child: const Text(
                        'НАЧАТЬ ИГРУ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _showSettings,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFBBADA0),
                              foregroundColor: const Color(0xFFF9F6F2),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                            ),
                            child: const Text(
                              'НАСТРОЙКИ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _toggleMusic,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBBADA0),
                            foregroundColor: const Color(0xFFF9F6F2),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          child: Icon(
                            GameSettings.isMusicEnabled ? Icons.music_note : Icons.music_off,
                            size: 24,
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
    );
  }
}
