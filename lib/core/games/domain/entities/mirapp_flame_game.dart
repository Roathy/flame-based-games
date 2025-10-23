import 'package:flame/game.dart';
import 'game_level_config.dart';

abstract class MirappFlameGame extends FlameGame {
  final GameLevelConfig levelConfig;
  final Function(bool success) onGameFinishedCallback;

  MirappFlameGame({required this.levelConfig, required this.onGameFinishedCallback});

  void onGameFinished(bool success) {
    onGameFinishedCallback(success);
  }
}
