import 'package:flame/components.dart';
import 'package:flame_based_games/core/games/domain/entities/mirapp_flame_game.dart';
import 'package:flame_based_games/core/games/domain/enums/game_status.dart';
import 'package:flame_based_games/features/tap_game/domain/entities/tap_game_parameters.dart';
import 'package:flutter/material.dart';

import 'package:flame_based_games/core/games/domain/entities/game_level_config.dart';

class TapGame extends MirappFlameGame {
  TapGame({required GameLevelConfig levelConfig}) : super(levelConfig: levelConfig);

  @override
  ValueNotifier<int> get scoreNotifier => ValueNotifier(0);

  @override
  ValueNotifier<int> get mistakesNotifier => ValueNotifier(0);

  @override
  ValueNotifier<int> get timeNotifier => ValueNotifier(0);

  @override
  ValueNotifier<String> get categoryNotifier => ValueNotifier('');

  @override
  Future<void> onLoad() async {
    try {
      await super.onLoad();
      final gameParameters = levelConfig.gameParameters as TapGameParameters;
      add(SquareComponent(color: gameParameters.squareColor));
    } catch (e) {
      print('Error loading TapGame: $e');
      gameStatusNotifier.value = GameStatus.error;
    }
  }
}

class SquareComponent extends PositionComponent {
  final Color color;

  SquareComponent({required this.color}) : super(size: Vector2.all(100));

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = color;
    canvas.drawRect(size.toRect(), paint);
  }
}