
import 'package:equatable/equatable.dart';

class BouncingWordsGameParameters extends Equatable {
  final List<String> wordPool;
  final int wordCount;
  final double wordSpeed;
  final int timeLimit;
  final int targetScore;

  const BouncingWordsGameParameters({
    required this.wordPool,
    this.wordCount = 5,
    this.wordSpeed = 100.0,
    this.timeLimit = 45,
    this.targetScore = 10,
  });

  BouncingWordsGameParameters copyWith({
    List<String>? wordPool,
    int? wordCount,
    double? wordSpeed,
    int? timeLimit,
    int? targetScore,
  }) {
    return BouncingWordsGameParameters(
      wordPool: wordPool ?? this.wordPool,
      wordCount: wordCount ?? this.wordCount,
      wordSpeed: wordSpeed ?? this.wordSpeed,
      timeLimit: timeLimit ?? this.timeLimit,
      targetScore: targetScore ?? this.targetScore,
    );
  }

  @override
  List<Object?> get props => [
        wordPool,
        wordCount,
        wordSpeed,
        timeLimit,
        targetScore,
      ];
}
