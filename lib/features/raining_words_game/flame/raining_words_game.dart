import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame_based_games/core/games/domain/enums/game_status.dart';

import 'package:flame_based_games/core/games/domain/entities/mirapp_flame_game.dart';
import 'package:flame_based_games/features/raining_words_game/flame/word_component.dart';

class RainingWordsGame extends MirappFlameGame {
  List<String> _wordList = [];
  double _speed = 100.0;
  int _currentWordIndex = 0;
  int _score = 0;
  final Random _random = Random();

  RainingWordsGame({required super.levelConfig});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _wordList = (levelConfig.parameters['word_list'] as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    _speed = levelConfig.parameters['speed'] as double;
  }

  @override
  void onMount() {
    super.onMount();
    gameStatusNotifier.addListener(_gameStatusListener);
  }

  @override
  void onRemove() {
    gameStatusNotifier.removeListener(_gameStatusListener);
    super.onRemove();
  }

  void _gameStatusListener() {
    if (gameStatusNotifier.value == GameStatus.playing) {
      _startGame();
    } else if (gameStatusNotifier.value == GameStatus.initial) {
      _resetGame();
    }
  }

  void _startGame() {
    _resetGame(); // Ensure a clean start
    _addWordsToGame();
  }

  void _resetGame() {
    _currentWordIndex = 0;
    _score = 0;
    removeAll(children.whereType<WordComponent>()); // Clear existing words
  }

  void _addWordsToGame() {
    for (int i = 0; i < _wordList.length; i++) {
      final word = _wordList[i];
      final randomSpeed = _speed * (0.5 + _random.nextDouble()); // Random speed between 0.5x and 1.5x of base speed
      final wordComponent = WordComponent(
        word: word,
        onTapped: () => _onWordTapped(word),
        speed: randomSpeed,
      );
      add(wordComponent);
      _setWordPosition(wordComponent);
    }
  }

  void _setWordPosition(WordComponent wordComponent) {
    wordComponent.position = Vector2(
      wordComponent.width / 2 + _random.nextDouble() * (size.x - wordComponent.width),
      -wordComponent.height - (_random.nextDouble() * size.y), // Start above screen with some randomness
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameStatusNotifier.value != GameStatus.playing) {
      return; // Only update game logic if playing
    }

    for (final component in children.whereType<WordComponent>()) {
      component.position.y += component.speed * dt;

      if (component.position.y > size.y) {
        _setWordPosition(component);
      }
    }
  }

  void _onWordTapped(String tappedWord) {
    if (gameStatusNotifier.value != GameStatus.playing) {
      return; // Only process taps if playing
    }

    if (tappedWord == _wordList[_currentWordIndex]) {
      _score++;
      final tappedComponent = children.whereType<WordComponent>().firstWhere(
            (element) => element.word == tappedWord,
          );
      remove(tappedComponent);

      _currentWordIndex++;
      if (_currentWordIndex >= _wordList.length) {
        onGameFinished(true); // Game finished successfully
      }
    } else {
      onGameFinished(false); // Game finished with failure
    }
  }
}
