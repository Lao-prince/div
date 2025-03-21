import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_cell.dart';
import 'draggable_number.dart';
import 'game_result.dart';
import 'game_settings.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const String _resultsKey = 'game_results';
  static const int _maxStoredResults = 10;
  
  static const int gridSize = 4;
  late List<List<int?>> grid;
  int? currentNumber;
  int score = 0;
  bool isDragging = false;
  final Random _random = Random();
  List<GameResult> previousResults = [];
  bool _resultSaved = false;
  
  int _comboMultiplier = 1;
  int _lastMoveTime = 0;

  @override
  void initState() {
    super.initState();
    _loadPreviousResults();
    _initializeGame();
  }

  Future<void> _loadPreviousResults() async {
    final prefs = await SharedPreferences.getInstance();
    final resultsJson = prefs.getStringList(_resultsKey) ?? [];
    setState(() {
      previousResults = resultsJson
          .map((json) => GameResult.fromJson(jsonDecode(json)))
          .toList()
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    });
  }

  int get _bestScore {
    if (previousResults.isEmpty) return 0;
    return previousResults
        .map((result) => result.score)
        .reduce((value, element) => value > element ? value : element);
  }

  void _initializeGame() {
    setState(() {
      grid = List.generate(
        gridSize,
        (_) => List.generate(gridSize, (_) => null),
      );
      score = 0;
      _resultSaved = false;
      _generateNewNumber();
    });
  }

  void _generateNewNumber() {
    if (_isGameOver() || currentNumber != null) return;

    List<int> existingNumbers = [];
    for (var row in grid) {
      for (var cell in row) {
        if (cell != null) {
          existingNumbers.add(cell);
        }
      }
    }

    int newNumber;
    if (existingNumbers.isEmpty) {
      if (_random.nextBool()) {
        newNumber = _random.nextInt(9) * 2 + 2;
      } else {
        newNumber = (_random.nextInt(3) + 2) * (_random.nextInt(3) + 2);
      }
    } else {
      int strategy = _random.nextInt(4);
      
      switch (strategy) {
        case 0:
          int baseNumber = existingNumbers[_random.nextInt(existingNumbers.length)];
          int multiplier = _random.nextInt(4) + 2;
          newNumber = baseNumber * multiplier;
          break;
          
        case 1:
          newNumber = _random.nextInt(17) + 2;
          int attempts = 0;
          while (existingNumbers.any((n) => _findGCD(n, newNumber) > 1) && attempts < 10) {
            newNumber = _random.nextInt(17) + 2;
            attempts++;
          }
          break;
          
        case 2:
          newNumber = (_random.nextInt(5) + 2) * (_random.nextInt(5) + 2);
          break;

        case 3:
          newNumber = _random.nextInt(20) + 2;
          int attempts = 0;
          while (!existingNumbers.any((n) => _findGCD(n, newNumber) > 1) && attempts < 10) {
            newNumber = _random.nextInt(20) + 2;
            attempts++;
          }
          break;

        default:
          newNumber = _random.nextInt(17) + 2;
      }

      if (newNumber > 100) {
        List<int> factors = [];
        int n = newNumber;
        for (int i = 2; i <= n; i++) {
          while (n % i == 0) {
            factors.add(i);
            n = n ~/ i;
          }
        }
        if (factors.length >= 2) {
          factors.shuffle();
          newNumber = factors[0] * factors[1];
        } else {
          newNumber = newNumber % 30 + 2;
        }
      }
    }

    currentNumber = newNumber;
  }

  int _findGCD(int a, int b) {
    while (b != 0) {
      var t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  void _processCell(int row, int col, int number) {
    if (grid[row][col] != null || currentNumber == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastMoveTime < 3000) {
      _comboMultiplier = min(_comboMultiplier + 1, 5);
    } else {
      _comboMultiplier = 1;
    }
    _lastMoveTime = now;

    final processedNumber = currentNumber;
    currentNumber = null;
    isDragging = false;

    setState(() {
      grid[row][col] = number;
      int totalScore = 0;
      bool hadInteraction = false;
      int placedNumber = number;

      List<Point<int>> neighbors = [
        Point(row - 1, col),
        Point(row + 1, col),
        Point(row, col - 1),
        Point(row, col + 1),
      ];

      bool hasAnyInteraction = false;
      for (var point in neighbors) {
        if (point.x >= 0 && point.x < gridSize && 
            point.y >= 0 && point.y < gridSize && 
            grid[point.x][point.y] != null) {
          int neighborValue = grid[point.x][point.y]!;
          if (_findGCD(placedNumber, neighborValue) > 1) {
            hasAnyInteraction = true;
            break;
          }
        }
      }

      if (hasAnyInteraction) {
        for (var point in neighbors) {
          if (point.x >= 0 && point.x < gridSize && 
              point.y >= 0 && point.y < gridSize && 
              grid[point.x][point.y] != null) {
            int neighborValue = grid[point.x][point.y]!;
            int gcd = _findGCD(placedNumber, neighborValue);
            
            if (gcd > 1) {
              hadInteraction = true;
              int newNeighborValue = neighborValue ~/ gcd;
              if (newNeighborValue > 1) {
                totalScore += (neighborValue - newNeighborValue) * gcd;
                grid[point.x][point.y] = newNeighborValue;
              } else {
                totalScore += neighborValue * 2;
                grid[point.x][point.y] = null;
              }
              
              int newPlacedNumber = placedNumber ~/ gcd;
              if (newPlacedNumber > 1) {
                placedNumber = newPlacedNumber;
              } else {
                placedNumber = 0;
              }
            }
          }
        }

        if (placedNumber <= 1) {
          grid[row][col] = null;
        } else {
          grid[row][col] = placedNumber;
          totalScore += number - placedNumber;
        }
      }

      totalScore *= _comboMultiplier;
      score += totalScore;

      if (_isGameOver()) {
        _handleGameOver();
      } else {
        _generateNewNumber();
      }
    });
  }

  bool _isGameOver() {
    // Если есть пустые клетки, игра продолжается
    if (grid.any((row) => row.any((cell) => cell == null))) {
      return false;
    }

    // Если поле заполнено, проверяем возможные взаимодействия
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        List<Point<int>> neighbors = [
          Point(i - 1, j),
          Point(i + 1, j),
          Point(i, j - 1),
          Point(i, j + 1),
        ];

        for (var point in neighbors) {
          if (point.x >= 0 && point.x < gridSize && 
              point.y >= 0 && point.y < gridSize) {
            int gcd = _findGCD(grid[i][j]!, grid[point.x][point.y]!);
            if (gcd > 1) return false;
          }
        }
      }
    }
    
    // Если поле заполнено и нет возможных взаимодействий - игра окончена
    return true;
  }

  void _handleGameOver() {
    if (!_resultSaved) {
      _resultSaved = true;
      _saveResult(score);
    }
  }

  Future<void> _saveResult(int score) async {
    final result = GameResult(
      score: score,
      dateTime: DateTime.now(),
    );
    
    previousResults.insert(0, result);
    if (previousResults.length > _maxStoredResults) {
      previousResults.removeLast();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _resultsKey,
      previousResults.map((r) => jsonEncode(r.toJson())).toList(),
    );
  }

  void _showResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Предыдущие результаты',
          style: TextStyle(
            color: Color(0xFF776E65),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: previousResults.length,
            itemBuilder: (context, index) {
              final result = previousResults[index];
              return ListTile(
                title: Text(
                  'Счет: ${result.score}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF776E65),
                  ),
                ),
                subtitle: Text(
                  '${result.dateTime.day}.${result.dateTime.month}.${result.dateTime.year} '
                  '${result.dateTime.hour}:${result.dateTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
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
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return ListTile(
              title: const Text('Режим перетаскивания'),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - 32;
    final cellSize = (availableWidth - 32) / gridSize;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8EF),
      appBar: AppBar(
        title: const Text(
          'Div',
          style: TextStyle(
            color: Color(0xFF776E65),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFAF8EF),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.history,
              color: Color(0xFF776E65),
            ),
            onPressed: _showResults,
            tooltip: 'История игр',
          ),
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Color(0xFF776E65),
            ),
            onPressed: _initializeGame,
            tooltip: 'Начать заново',
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Color(0xFF776E65),
            ),
            onPressed: _showSettings,
            tooltip: 'Настройки',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF776E65),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'СЧЕТ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEEE4DA),
                          ),
                        ),
                        Text(
                          score.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF9F6F2),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 2,
                      height: 40,
                      color: Color(0xFFEEE4DA),
                    ),
                    Column(
                      children: [
                        const Text(
                          'РЕКОРД',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEEE4DA),
                          ),
                        ),
                        Text(
                          _bestScore.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF9F6F2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFBBADA0),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(gridSize, (row) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(gridSize, (col) {
                        return SizedBox(
                          width: cellSize,
                          height: cellSize,
                          child: GameCell(
                            value: grid[row][col],
                            onDrop: GameSettings.gameMode == GameMode.dragAndDrop 
                                ? (number) => _processCell(row, col, number)
                                : null,
                            onTap: GameSettings.gameMode == GameMode.tap && currentNumber != null
                                ? () => _processCell(row, col, currentNumber!)
                                : null,
                            canAcceptDrop: grid[row][col] == null && 
                                (GameSettings.gameMode == GameMode.dragAndDrop || currentNumber != null),
                            currentNumber: currentNumber,
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 40),
              if (_isGameOver())
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBBADA0),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Игра окончена!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF9F6F2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Итоговый счет: $score',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFFF9F6F2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _initializeGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8F7A66),
                          foregroundColor: const Color(0xFFF9F6F2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text(
                          'Начать заново',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (currentNumber != null && !_isGameOver())
                GameSettings.gameMode == GameMode.dragAndDrop
                  ? DraggableNumber(
                      number: currentNumber!,
                      onDragStarted: () => setState(() => isDragging = true),
                      onDragEnd: () => setState(() => isDragging = false),
                    )
                  : Container(
                      width: 72,
                      height: 72,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8F7A66),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            currentNumber.toString(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              if (_comboMultiplier > 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8F7A66),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'КОМБО x$_comboMultiplier',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF9F6F2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
