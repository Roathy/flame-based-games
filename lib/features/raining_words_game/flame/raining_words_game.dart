import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_based_games/core/games/domain/enums/game_status.dart';

import 'package:flame_based_games/core/games/domain/entities/mirapp_flame_game.dart';
import 'package:flame_based_games/features/raining_words_game/flame/word_component.dart';
import 'package:flutter/material.dart';

class RainingWordsGame extends MirappFlameGame {
  List<String> _wordList = [];
  double _speed = 100.0;
  int _currentWordIndex = 0;
  int _wordsSpawned = 0;
  int _score = 0;
  final Random _random = Random();
  Timer? _spawnTimer;

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
    _spawnTimer?.cancel();
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
    _spawnTimer = Timer.periodic(const Duration(seconds: 1, milliseconds: 500), (timer) {
      _spawnWord();
    });
  }

  void _resetGame() {
    _currentWordIndex = 0;
    _score = 0;
    _wordsSpawned = 0;
    _spawnTimer?.cancel();
    removeAll(children.whereType<WordComponent>()); // Clear existing words
  }

  void _spawnWord() {
    if (_wordsSpawned >= _wordList.length) {
      _spawnTimer?.cancel();
      return;
    }

    final word = _wordList[_wordsSpawned];
    final randomSpeed = _speed * (0.5 + _random.nextDouble());
    final wordComponent = WordComponent(
      word: word,
      onTapped: () => _onWordTapped(word),
      speed: randomSpeed,
      color: _generateReadableColor(),
    );
    add(wordComponent);
    _setWordPosition(wordComponent);
    _wordsSpawned++;
  }

  Color _generateReadableColor() {
    // Generate a color with high saturation and lightness to be readable on black
    return HSLColor.fromAHSL(
      1.0, // Alpha
      _random.nextDouble() * 360, // Hue
      0.7 + _random.nextDouble() * 0.3, // Saturation (0.7 to 1.0)
      0.6 + _random.nextDouble() * 0.2, // Lightness (0.6 to 0.8)
    ).toColor();
  }

  void _setWordPosition(WordComponent wordComponent) {
    wordComponent.position = Vector2(
      wordComponent.width / 2 + _random.nextDouble() * (size.x - wordComponent.width),
      -wordComponent.height,
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
        // When a word goes off-screen, treat it as a failure
        onGameFinished(false);
        break; // End game immediately
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
      if (_score >= _wordList.length) {
        onGameFinished(true); // Game finished successfully
      }
    } else {
      onGameFinished(false); // Game finished with failure
    }
  }
}
