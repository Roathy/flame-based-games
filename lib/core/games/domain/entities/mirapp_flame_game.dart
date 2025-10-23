import 'package:flame/game.dart';
import 'game_level_config.dart';

abstract class MirappFlameGame extends FlameGame {
  final GameLevelConfig levelConfig;

  MirappFlameGame({required this.levelConfig});

  void onGameFinished(bool success);
}
