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

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF776E65),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return ListTile(
              title: Text(
                GameSettings.gameMode == GameMode.dragAndDrop 
                    ? 'Drag & Drop Mode' 
                    : 'Tap Mode',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF776E65),
                ),
              ),
              trailing: Switch(
                value: GameSettings.gameMode == GameMode.dragAndDrop,
                onChanged: (value) {
                  setDialogState(() {
                    GameSettings.gameMode = value ? GameMode.dragAndDrop : GameMode.tap;
                  });
                  setState(() {});
                },
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'START GAME',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                  'How to Play',
                                  style: TextStyle(
                                    color: Color(0xFF776E65),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Game Rules:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF776E65),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        '1. Place numbers on the grid, interacting with adjacent cells\n'
                                        '2. If adjacent numbers have a common divisor greater than 1, they interact\n'
                                        '3. During interaction, numbers are divided by their greatest common divisor\n'
                                        '4. If the division result equals 1, the cell is cleared\n'
                                        '5. Points are awarded for each interaction\n'
                                        '6. Consecutive interactions create combos (up to x5)\n'
                                        '7. Game ends when the grid is full and no interactions are possible',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF776E65),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Example:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF776E65),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFEEE4DA),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                _buildExampleCell('12'),
                                                const SizedBox(width: 8),
                                                _buildExampleCell('8'),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              '↓ GCD = 4 ↓',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF776E65),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                _buildExampleCell('3'),
                                                const SizedBox(width: 8),
                                                _buildExampleCell('2'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Game Modes:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF776E65),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        '• Tap Mode: select a cell to place a number\n'
                                        '• Drag & Drop Mode: drag the number to the desired cell',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF776E65),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text(
                                      'Got it',
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
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBBADA0),
                            foregroundColor: const Color(0xFFF9F6F2),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'HOW TO PLAY',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _showSettings,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBBADA0),
                            foregroundColor: const Color(0xFFF9F6F2),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'SETTINGS',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
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
}
