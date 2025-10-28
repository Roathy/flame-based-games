import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_based_games/core/games/domain/enums/game_status.dart';

import 'package:flame_based_games/core/games/domain/entities/mirapp_flame_game.dart';
import 'package:flame_based_games/features/raining_words_game/data/vocabulary_data.dart';
import 'package:flame_based_games/features/raining_words_game/flame/word_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../domain/enums/shuffling_method.dart';

class RainingWordsGame extends MirappFlameGame {
  List<String> _wordList = []; // Used for ShufflingMethod.random
  final List<String> _shuffleBag = []; // Used for ShufflingMethod.shuffleBag
  double _speed = 100.0;
  int _wordsSpawned = 0;
  final Random _random = Random();

  List<String>? _targetCategory;
  String? _targetCategoryName;

  final ValueNotifier<int> _scoreNotifier = ValueNotifier(0);
  final ValueNotifier<int> _mistakesNotifier = ValueNotifier(0);
  final ValueNotifier<int> _timeNotifier = ValueNotifier(45);

  ValueNotifier<int> get scoreNotifier => _scoreNotifier;
  ValueNotifier<int> get mistakesNotifier => _mistakesNotifier;
  ValueNotifier<int> get timeNotifier => _timeNotifier;

  late FlutterTts flutterTts;
  late final ShufflingMethod shufflingMethod;

  TimerComponent? _spawnTimer;
  TimerComponent? _boostTimer;

  RainingWordsGame({required super.levelConfig});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    flutterTts = FlutterTts();
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);

    _speed = levelConfig.parameters['speed'] as double;
    shufflingMethod = ShufflingMethod.values.firstWhere(
      (e) => e.toString() == 'ShufflingMethod.${levelConfig.parameters['shuffling_method']}',
      orElse: () => ShufflingMethod.random, // Default value if not found
    );
  }

  void _initializeWordPool() {
    switch (shufflingMethod) {
      case ShufflingMethod.random:
        _wordList = _generateDynamicWordPool();
        break;
      case ShufflingMethod.shuffleBag:
        _fillShuffleBag();
        break;
      case ShufflingMethod.deckBased:
        // TODO: Implement deck-based spawning
        break;
      case ShufflingMethod.weightedDistribution:
        // TODO: Implement weighted distribution
        break;
    }
  }

  List<String> _generateDynamicWordPool() {
    final List<String> dynamicPool = [];
    final categories = VocabularyData.vocabularyCategories.values.toList();

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

  void _fillShuffleBag() {
    _shuffleBag.clear();

    // Determine the number of words from target category and other categories
    // For example, 30% target words, 70% non-target words in a bag of 10
    const int bagSize = 10;
    const int targetWordsCount = 3;
    const int otherWordsCount = bagSize - targetWordsCount;

    // Add target words
    for (int i = 0; i < targetWordsCount; i++) {
      if (_targetCategory != null && _targetCategory!.isNotEmpty) {
        _shuffleBag.add(_targetCategory![_random.nextInt(_targetCategory!.length)]);
      }
    }

    // Add words from other categories
    final otherCategories = VocabularyData.vocabularyCategories.values.where((cat) => cat != _targetCategory).toList();
    for (int i = 0; i < otherWordsCount; i++) {
      if (otherCategories.isNotEmpty) {
        final randomCategory = otherCategories[_random.nextInt(otherCategories.length)];
        if (randomCategory.isNotEmpty) {
          _shuffleBag.add(randomCategory[_random.nextInt(randomCategory.length)]);
        }
      }
    }

    _shuffleBag.shuffle(_random);
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
    } else if (gameStatusNotifier.value == GameStatus.initial) {
      _resetGame();
    }
  }

  void _startGame() async {
    _resetGame(); // Ensure a clean start

    // Select a random target category
    final categoryKeys = VocabularyData.vocabularyCategories.keys.toList();
    _targetCategoryName = categoryKeys[_random.nextInt(categoryKeys.length)];
    _targetCategory = VocabularyData.vocabularyCategories[_targetCategoryName];

    // Initialize word pool based on shuffling method AFTER target category is selected
    _initializeWordPool();

    // Announce the target category
    if (_targetCategoryName != null) {
      await flutterTts.speak("Tap all the words from the category: $_targetCategoryName");
    }

    _spawnTimer = TimerComponent(
      period: 1.5,
      repeat: true,
      onTick: _spawnWord,
    );
    add(_spawnTimer!);

    if (shufflingMethod == ShufflingMethod.shuffleBag) {
      add(TimerComponent(
        period: 45,
        onTick: () => onGameFinished(false),
      ));
      add(TimerComponent(
        period: 1,
        repeat: true,
        onTick: () {
          if (_timeNotifier.value > 0) {
            _timeNotifier.value--;
          }
        },
      ));
    }
  }

  Future<void> replayCategoryAnnouncement() async {
    if (_targetCategoryName != null) {
      await flutterTts.speak("Tap all the words from the category: $_targetCategoryName");
    }
  }

  void _resetGame() {
    _scoreNotifier.value = 0;
    _mistakesNotifier.value = 0;
    _timeNotifier.value = 45;
    _wordsSpawned = 0;
    _spawnTimer = null;
    _boostTimer = null;
    removeAll(children.whereType<TimerComponent>());
    removeAll(children.whereType<WordComponent>()); // Clear existing words
    _wordList.clear(); // Clear _wordList for random method
    _shuffleBag.clear(); // Clear _shuffleBag for shuffle bag method
  }

  void _spawnWord() {
    if (_wordsSpawned >= 100) { // Game ends after 100 words are spawned
      removeAll(children.whereType<TimerComponent>());
      return;
    }

    String wordToSpawn;
    switch (shufflingMethod) {
      case ShufflingMethod.random:
        if (_wordsSpawned >= _wordList.length) {
          removeAll(children.whereType<TimerComponent>());
          return;
        }
        wordToSpawn = _wordList[_wordsSpawned];
        break;
      case ShufflingMethod.shuffleBag:
        if (_shuffleBag.isEmpty) {
          _fillShuffleBag();
        }
        wordToSpawn = _shuffleBag.removeAt(0);
        break;
      case ShufflingMethod.deckBased:
        // TODO: Implement deck-based spawning
        wordToSpawn = "DeckWord"; // Placeholder
        break;
      case ShufflingMethod.weightedDistribution:
        // TODO: Implement weighted distribution
        wordToSpawn = "WeightedWord"; // Placeholder
        break;
    }

    final randomSpeed = _speed * (0.5 + _random.nextDouble());
    final wordComponent = WordComponent(
      word: wordToSpawn,
      onTapped: () => _onWordTapped(wordToSpawn),
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
                      _mistakesNotifier.value++;
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
                    }        }
      }
    }
  }

  bool _onWordTapped(String tappedWord) {
    if (gameStatusNotifier.value != GameStatus.playing) {
      return false;
    }

      if (_targetCategory!.contains(tappedWord)) {
      _scoreNotifier.value++;

      // Speed boost logic
      _boostTimer?.removeFromParent(); // Reset existing boost timer
      _spawnTimer?.timer.limit = 1.5 / 2; // 2x speed

      _boostTimer = TimerComponent(
        period: 1, // 1 second
        onTick: () {
          _spawnTimer?.timer.limit = 1.5; // Revert to normal speed
          _boostTimer?.removeFromParent();
          _boostTimer = null;
        },
      );
      add(_boostTimer!);

      if (shufflingMethod == ShufflingMethod.shuffleBag) {
        if (_scoreNotifier.value >= 10) {
          onGameFinished(true);
        }
        _spawnWord();
      }
      return true;
    } else {
      _mistakesNotifier.value++;
      return false;
    }
  }
}
