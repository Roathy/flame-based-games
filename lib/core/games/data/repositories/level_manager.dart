import 'package:flame_based_games/features/bouncing_words_game/domain/entities/bouncing_words_game_parameters.dart';
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
      parameters: {
        'square_color': '0xFF00FF00',
      },
    ),
    const GameLevelConfig(
      id: '2',
      name: 'Raining Words',
      gameType: FlameGameType.rainingWordsGame,
      difficulty: Difficulty.medium,
      instruction: 'Tap the raining words in order!',
      parameters: {
        'word_list': ['hello', 'world', 'flutter', 'flame'],
        'speed': 100.0,
        'shuffling_method': 'random',
      },
    ),
    const GameLevelConfig(
      id: '3',
      name: 'Raining Words (Shuffle Bag)',
      gameType: FlameGameType.rainingWordsGame,
      difficulty: Difficulty.medium,
      instruction: 'Tap the raining words in order!',
      parameters: {
        'word_list': ['hello', 'world', 'flutter', 'flame'],
        'speed': 100.0,
        'shuffling_method': 'shuffleBag',
      },
    ),
    const GameLevelConfig(
        id: '4',
        name: 'Bouncing Words',
        gameType: FlameGameType.bouncingWordsGame,
        difficulty: Difficulty.easy,
        instruction: 'Tap the bouncing words!',
        bouncingWordsGameParameters: BouncingWordsGameParameters(
          wordPool: ['apple', 'banana', 'cherry', 'date', 'elderberry'],
          wordCount: 5,
          wordSpeed: 80.0,
          timeLimit: 45,
          targetScore: 10,
        )),
  ];
}
