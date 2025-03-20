class GameResult {
  final int score;
  final DateTime dateTime;

  GameResult({
    required this.score,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      score: json['score'] as int,
      dateTime: DateTime.parse(json['dateTime'] as String),
    );
  }
}
