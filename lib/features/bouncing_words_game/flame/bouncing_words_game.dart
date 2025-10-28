import 'package:flame_based_games/core/games/domain/entities/mirapp_flame_game.dart';
import 'package:flutter/foundation.dart';

class BouncingWordsGame extends MirappFlameGame {
  BouncingWordsGame({required super.levelConfig});

  @override
  ValueNotifier<int> get scoreNotifier => ValueNotifier(0);

  @override
  ValueNotifier<int> get mistakesNotifier => ValueNotifier(0);

  @override
  ValueNotifier<int> get timeNotifier => ValueNotifier(0);
}
