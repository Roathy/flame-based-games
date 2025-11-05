import 'package:flame/components.dart';
import 'package:flame_based_games/core/games/components/word_component.dart';
import 'package:flame_based_games/core/theme/flame_game_theme.dart';
import 'package:flutter/foundation.dart';
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
  late FlameGameTheme theme;
  late final RectangleComponent _background;

  final List<FlameGameTheme> _themes = [
    FlameGameTheme.dark(),
    FlameGameTheme.ocean(),
    FlameGameTheme.light(),
  ];
  int _currentThemeIndex = 0;

  ValueNotifier<int> get scoreNotifier;
  ValueNotifier<int> get mistakesNotifier;
  ValueNotifier<int> get timeNotifier;
  ValueNotifier<String> get categoryNotifier;

  MirappFlameGame({required this.levelConfig}) {
    theme = _themes[_currentThemeIndex];
  }

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

  void cycleTheme() {
    _currentThemeIndex = (_currentThemeIndex + 1) % _themes.length;
    theme = _themes[_currentThemeIndex];

    // Update background
    _background.paint.color = theme.backgroundColor;

    // Update all word components
    for (final component in children.whereType<WordComponent>()) {
      final newColor = colorFactory.generate(theme.backgroundColor);
      component.updateStyle(theme, newColor);
    }
  }

  void onGameFinished(bool success) {
    gameStatusNotifier.value =
        success ? GameStatus.finished : GameStatus.gameOver;
  }
}
