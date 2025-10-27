import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_based_games/core/games/domain/enums/game_status.dart';

import 'package:flame_based_games/core/games/domain/entities/mirapp_flame_game.dart';
import 'package:flame_based_games/features/raining_words_game/data/word_data.dart';
import 'package:flame_based_games/features/raining_words_game/flame/word_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class RainingWordsGame extends MirappFlameGame {
  List<String> _wordList = [];
  double _speed = 100.0;
  int _wordsSpawned = 0;
  final Random _random = Random();

  List<String>? _targetCategory;
  String? _targetCategoryName;

  final ValueNotifier<int> _scoreNotifier = ValueNotifier(0);
  final ValueNotifier<int> _mistakesNotifier = ValueNotifier(0);

  ValueNotifier<int> get scoreNotifier => _scoreNotifier;
  ValueNotifier<int> get mistakesNotifier => _mistakesNotifier;

  late FlutterTts flutterTts;

  RainingWordsGame({required super.levelConfig});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    flutterTts = FlutterTts();
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);

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
    flutterTts.stop();
    super.onRemove();
  }

  void _gameStatusListener() {
    if (gameStatusNotifier.value == GameStatus.playing) {
      _startGame();
    }
    else if (gameStatusNotifier.value == GameStatus.initial) {
      _resetGame();
    }
  }

  void _startGame() async {
    _resetGame(); // Ensure a clean start

    // Select a random target category
    _targetCategory = WordData.allCategories[_random.nextInt(WordData.allCategories.length)];
    _targetCategoryName = WordData.categoryNames[_targetCategory];

    // Announce the target category
    if (_targetCategoryName != null) {
      await flutterTts.speak("Tap all the words from the category: $_targetCategoryName");
    }

    add(TimerComponent(
      period: 1.5,
      repeat: true,
      onTick: _spawnWord,
    ));
  }

  Future<void> replayCategoryAnnouncement() async {
    if (_targetCategoryName != null) {
      await flutterTts.speak("Tap all the words from the category: $_targetCategoryName");
    }
  }

  void _resetGame() {
    _scoreNotifier.value = 0;
    _mistakesNotifier.value = 0;
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
        if (!component.animationTriggered) {
          component.animationTriggered = true;
          if (_targetCategory!.contains(component.word)) {
            // If a word from the target category is missed, shake other words and bounce
            for (final otherComponent in wordsOnScreen) {
              if (otherComponent != component) {
                otherComponent.shake();
              }
            }
            component.bounceAndDisappear();
          } else {
            // Words from other categories just disappear
            component.removeFromParent();
          }
        }
      }
    }

    // Check for game completion (all words spawned and either tapped or gone off-screen)
    if (_wordsSpawned >= _wordList.length && children.whereType<WordComponent>().isEmpty) {
      // Calculate how many words from the target category were in the _wordList
      final int targetWordsInPool = _wordList.where((word) => _targetCategory!.contains(word)).length;

      if (_scoreNotifier.value >= targetWordsInPool) {
        onGameFinished(true); // All target words tapped successfully
      } else {
        onGameFinished(false); // Some target words missed
      }
    }
  }

  void _onWordTapped(String tappedWord) {
    if (gameStatusNotifier.value != GameStatus.playing) {
      return; // Only process taps if playing
    }

    final tappedComponent = children.whereType<WordComponent>().firstWhere(
          (element) => element.word == tappedWord,
        );
    remove(tappedComponent);

    if (_targetCategory!.contains(tappedWord)) {
      _scoreNotifier.value++;
    } else {
      _mistakesNotifier.value++;
    }
  }
}

