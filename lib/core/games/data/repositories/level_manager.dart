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
  ];
}
