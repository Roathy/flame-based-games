import 'package:flutter/foundation.dart';
import 'package:flame/game.dart';
import '../enums/game_status.dart';
import 'game_level_config.dart';

abstract class MirappFlameGame extends FlameGame {
  final GameLevelConfig levelConfig;
  final ValueNotifier<GameStatus> gameStatusNotifier = ValueNotifier(GameStatus.initial);

  ValueNotifier<int> get scoreNotifier;
  ValueNotifier<int> get mistakesNotifier;
  ValueNotifier<int> get timeNotifier;

  MirappFlameGame({required this.levelConfig});

  void onGameFinished(bool success) {
    gameStatusNotifier.value = success ? GameStatus.finished : GameStatus.gameOver;
  }
}
