import 'package:flame/components.dart';
import 'package:flame_based_games/core/games/components/word_component.dart';
import 'package:flame_based_games/core/theme/flame_game_theme.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../enums/game_status.dart';
import 'game_level_config.dart';

import 'package:flame_based_games/core/utils/readable_color_factory.dart';

abstract class MirappFlameGame extends FlameGame {
  final GameLevelConfig levelConfig;
  final ValueNotifier<GameStatus> gameStatusNotifier =
      ValueNotifier(GameStatus.initial);

  final colorFactory = ReadableColorFactory();
  final FlameGameTheme theme;
  late final RectangleComponent _background;

  ValueNotifier<int> get scoreNotifier;
  ValueNotifier<int> get mistakesNotifier;
  ValueNotifier<int> get timeNotifier;
  ValueNotifier<String> get categoryNotifier;

  Map<String, Widget Function(BuildContext, FlameGame)> get gameSpecificOverlays;

  MirappFlameGame({required this.levelConfig, required this.theme});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _background = RectangleComponent(
      size: size,
      paint: Paint()..color = theme.backgroundColor,
      priority: -1,
    );
    add(_background);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) {
      _background.size = size;
    }
  }

  void updateTheme(FlameGameTheme newTheme) {
    // Update background
    _background.paint.color = newTheme.backgroundColor;

    // Update all word components
    for (final component in children.whereType<WordComponent>()) {
      final newColor = colorFactory.generate(newTheme.backgroundColor);
      component.updateStyle(newTheme, newColor);
    }
  }

  void onGameFinished(bool success) {
    gameStatusNotifier.value =
        success ? GameStatus.finished : GameStatus.gameOver;
  }
}
