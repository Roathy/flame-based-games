import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_based_games/core/games/domain/enums/game_status.dart';

import 'package:flame_based_games/core/games/domain/entities/mirapp_flame_game.dart';
import 'package:flame_based_games/features/raining_words_game/data/word_data.dart';
import 'package:flame_based_games/features/raining_words_game/flame/word_component.dart';
import 'package:flutter/material.dart';

class RainingWordsGame extends MirappFlameGame {
  List<String> _wordList = [];
  double _speed = 100.0;
  int _currentWordIndex = 0;
  int _wordsSpawned = 0;
  int _score = 0;
  final Random _random = Random();

  RainingWordsGame({required super.levelConfig});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _wordList = _generateDynamicWordPool();
    _speed = levelConfig.parameters['speed'] as double;
  }

  List<String> _generateDynamicWordPool() {
    final List<String> dynamicPool = [];
    final List<List<String>> categories = WordData.allCategories;

    for (int i = 0; i < 10; i++) { // 10 iterations to get 10 words from each category
      for (final category in categories) {
        if (category.isNotEmpty) {
          dynamicPool.add(category[_random.nextInt(category.length)]);
        }
      }
    }
    dynamicPool.shuffle(_random);
    return dynamicPool;
  }

  @override
  void onMount() {
    super.onMount();
    gameStatusNotifier.addListener(_gameStatusListener);
  }

  @override
  void onRemove() {
    removeAll(children.whereType<TimerComponent>());
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
    add(TimerComponent(
      period: 1.5,
      repeat: true,
      onTick: _spawnWord,
    ));
  }

  void _resetGame() {
    _currentWordIndex = 0;
    _score = 0;
    _wordsSpawned = 0;
    removeAll(children.whereType<TimerComponent>());
    removeAll(children.whereType<WordComponent>()); // Clear existing words
  }

  void _spawnWord() {
    if (_wordsSpawned >= _wordList.length) {
      removeAll(children.whereType<TimerComponent>());
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

    // Check for words going off-screen
    final wordsOnScreen = children.whereType<WordComponent>().toList();
    for (final component in wordsOnScreen) {
      component.position.y += component.speed * dt;

      if (component.position.y > size.y) {
        component.removeFromParent();
      }
    }

    // Check for game completion (all words spawned and either tapped or gone off-screen)
    if (_wordsSpawned >= _wordList.length && children.whereType<WordComponent>().isEmpty) {
      if (_score >= _wordList.length) {
        onGameFinished(true); // All words tapped successfully
      } else {
        onGameFinished(false); // Some words missed
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
      // Game completion check is now in update method
    } else {
      // Tapped wrong word, game finishes with failure
      onGameFinished(false);
    }
  }
}

