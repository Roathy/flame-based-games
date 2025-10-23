import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame_based_games/core/games/domain/entities/game_level_config.dart';
import 'package:flame_based_games/core/games/domain/entities/mirapp_flame_game.dart';
import 'package:flame_based_games/features/raining_words_game/flame/word_component.dart';

class RainingWordsGame extends MirappFlameGame {
  List<String> _wordList = [];
  double _speed = 100.0;
  int _currentWordIndex = 0;
  int _score = 0;
  final Random _random = Random();

  RainingWordsGame({required super.levelConfig, required super.onGameFinishedCallback});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _wordList = (levelConfig.parameters['word_list'] as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    _speed = levelConfig.parameters['speed'] as double;

    _addWordsToGame();
  }

  void _addWordsToGame() {
    for (int i = 0; i < _wordList.length; i++) {
      final word = _wordList[i];
      final wordComponent = WordComponent(
        word: word,
        onTapped: () => _onWordTapped(word),
      );
      add(wordComponent);
      _setWordPosition(wordComponent);
    }
  }

  void _setWordPosition(WordComponent wordComponent) {
    wordComponent.position = Vector2(
      _random.nextDouble() * (size.x - wordComponent.width),
      _random.nextDouble() * (size.y - wordComponent.height),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (final component in children.whereType<WordComponent>()) {
      component.position.y += _speed * dt;

      if (component.position.y > size.y) {
        _setWordPosition(component);
      }
    }
  }

  void _onWordTapped(String tappedWord) {
    if (tappedWord == _wordList[_currentWordIndex]) {
      _score++;
      final tappedComponent = children.whereType<WordComponent>().firstWhere(
            (element) => element.word == tappedWord,
          );
      remove(tappedComponent);

      _currentWordIndex++;
      if (_currentWordIndex >= _wordList.length) {
        onGameFinished(true);
      }
    } else {
      onGameFinished(false);
    }
  }
}
