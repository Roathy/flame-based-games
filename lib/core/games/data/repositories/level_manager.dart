import 'package:flame_based_games/features/bouncing_words_game/domain/entities/bouncing_words_game_parameters.dart';
import 'package:flame_based_games/features/raining_words_game/domain/entities/raining_words_game_parameters.dart';
import 'package:flame_based_games/features/tap_game/domain/entities/tap_game_parameters.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/game_level_config.dart';
import '../../domain/enums/difficulty.dart';
import '../../domain/enums/flame_game_type.dart';

class LevelManager {
  static final List<GameLevelConfig> levels = [
    const GameLevelConfig(
      id: '1',
      name: 'Tap the square',
      gameType: FlameGameType.tapGame,
      difficulty: Difficulty.easy,
      instruction: 'Tap the square as fast as you can!',
      gameParameters: TapGameParameters(
        squareColor: Colors.green,
      ),
    ),
    const GameLevelConfig(
      id: '2',
      name: 'Raining Words',
      gameType: FlameGameType.rainingWordsGame,
      difficulty: Difficulty.medium,
      instruction: 'Tap the raining words in order!',
      gameParameters: RainingWordsGameParameters(
        wordList: ['hello', 'world', 'flutter', 'flame'],
        speed: 100.0,
        shufflingMethod: 'random',
      ),
    ),
    const GameLevelConfig(
      id: '3',
      name: 'Raining Words (Shuffle Bag)',
      gameType: FlameGameType.rainingWordsGame,
      difficulty: Difficulty.medium,
      instruction: 'Tap the raining words in order!',
      gameParameters: RainingWordsGameParameters(
        wordList: ['hello', 'world', 'flutter', 'flame'],
        speed: 100.0,
        shufflingMethod: 'shuffleBag',
      ),
    ),
    const GameLevelConfig(
        id: '4',
        name: 'Bouncing Words',
        gameType: FlameGameType.bouncingWordsGame,
        difficulty: Difficulty.easy,
        instruction: 'Tap the bouncing words!',
        gameParameters: BouncingWordsGameParameters(
          wordPool: ['apple', 'banana', 'cherry', 'date', 'elderberry'],
          wordCount: 5,
          wordSpeed: 80.0,
          timeLimit: 45,
          targetScore: 10,
        )),
  ];
}
