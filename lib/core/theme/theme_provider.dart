import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flame_based_games/core/theme/flame_game_theme.dart';

part 'theme_provider.g.dart';

@riverpod
class CurrentFlameTheme extends _$CurrentFlameTheme {
  static final _allThemes = [
    FlameGameTheme.dark(),
    FlameGameTheme.ocean(),
    FlameGameTheme.light(),
  ];

  @override
  FlameGameTheme build() {
    return FlameGameTheme.dark(); // Default theme
  }

  void cycleTheme() {
    final currentIndex = _allThemes.indexWhere(
        (theme) => theme.backgroundColor == state.backgroundColor);
    final nextIndex = (currentIndex + 1) % _allThemes.length;
    state = _allThemes[nextIndex];
  }

  void setTheme(FlameGameTheme theme) {
    state = theme;
  }
}