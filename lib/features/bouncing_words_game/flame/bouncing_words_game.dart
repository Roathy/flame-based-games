import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_based_games/core/games/components/word_component.dart';
import 'package:flame_based_games/core/games/domain/entities/mirapp_flame_game.dart';
import 'package:flame_based_games/core/games/domain/enums/game_status.dart';
import 'package:flame_based_games/features/bouncing_words_game/domain/entities/bouncing_words_game_parameters.dart';
import 'package:flame_based_games/core/di/injection_container.dart';
import 'package:flame_based_games/features/bouncing_words_game/domain/repositories/bouncing_words_repository.dart';
import 'package:flutter/material.dart';

class BouncingWordsGame extends MirappFlameGame {
  final ValueNotifier<int> _scoreNotifier = ValueNotifier(0);
  final ValueNotifier<int> _mistakesNotifier = ValueNotifier(0);
  final ValueNotifier<int> _timeNotifier = ValueNotifier(45);

  @override
  ValueNotifier<int> get scoreNotifier => _scoreNotifier;
  @override
  ValueNotifier<int> get mistakesNotifier => _mistakesNotifier;
  @override
  ValueNotifier<int> get timeNotifier => _timeNotifier;

  final Random _random = Random();
  late BouncingWordsGameParameters _gameParameters;
  final Map<WordComponent, Vector2> _wordVelocities = {};
  final BouncingWordsRepository _bouncingWordsRepository = sl<BouncingWordsRepository>();

  TextComponent? _targetWordText;
  String? _currentTargetWord;
  final List<String> _activeWords = [];

  BouncingWordsGame({required super.levelConfig});

  @override
  Future<void> onLoad() async {
    try {
      await super.onLoad();
      _gameParameters = levelConfig.gameParameters as BouncingWordsGameParameters;

      final distractorWords = await _bouncingWordsRepository.getDistractorWords();
      _gameParameters = _gameParameters.copyWith(wordPool: distractorWords);

      _targetWordText = TextComponent(
        text: '',
        anchor: Anchor.topCenter,
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 32,
            color: Colors.yellow, // Make color distinct
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      camera.viewport.add(_targetWordText!);
    } catch (e) {
      print('Error loading BouncingWordsGame: $e');
      gameStatusNotifier.value = GameStatus.error;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _targetWordText?.position = Vector2(size.x / 2, 40);
  }

  void _startGame() {
    _resetGame();
    _spawnWords();
    _setNewTargetWord();

    add(TimerComponent(
      period: 1,
      repeat: true,
      onTick: () {
        if (_timeNotifier.value > 0) {
          _timeNotifier.value--;
        } else {
          onGameFinished(false);
        }
      },
    ));
  }

  void _resetGame() {
    _scoreNotifier.value = 0;
    _mistakesNotifier.value = 0;
    _timeNotifier.value = _gameParameters.timeLimit;
    _currentTargetWord = null;
    _targetWordText?.text = '';
    _activeWords.clear();
    _wordVelocities.clear();
    removeAll(children.whereType<WordComponent>());
    removeAll(children.whereType<TimerComponent>());
  }

  void _spawnWords() {
    // Guard against spawning before the game has a size.
    if (size.x == 0 || size.y == 0) {
      return;
    }

    final Set<String> wordsToSpawn = {};
    while (wordsToSpawn.length < _gameParameters.wordCount) {
      wordsToSpawn.add(_gameParameters.wordPool[_random.nextInt(_gameParameters.wordPool.length)]);
    }

    _activeWords.addAll(wordsToSpawn);
    for (final word in _activeWords) {
      _spawnSingleWord(word);
    }
  }

  void _spawnSingleWord(String word) {
    final initialPosition = Vector2(size.x / 2, size.y / 2);

    // Use angles for a robust random direction.
    final angle = _random.nextDouble() * 2 * pi;
    final velocity = Vector2(cos(angle), sin(angle)) * _gameParameters.wordSpeed;

    final wordComponent = WordComponent(
      word: word,
      color: _generateReadableColor(),
      onTapped: () {
        if (word == _currentTargetWord) {
          _scoreNotifier.value++;

          // --- Round Clear Logic ---
          final otherWords = children.whereType<WordComponent>().where((c) => c.word != word).toList();
          for (final otherWord in otherWords) {
            otherWord.explode();
            otherWord.removeFromParent();
            _wordVelocities.remove(otherWord);
            _activeWords.remove(otherWord.word);
          }

          if (_scoreNotifier.value >= _gameParameters.targetScore) {
            onGameFinished(true);
          } else {
            // Short delay before starting the next round
            add(TimerComponent(period: 0.5, onTick: () {
              _spawnWords();
              _setNewTargetWord();
            }));
          }
          return true; // Correct tap
        } else {
          _mistakesNotifier.value++;
          return false; // Incorrect tap
        }
      },
    );

    wordComponent.position = initialPosition;
    _wordVelocities[wordComponent] = velocity;
    add(wordComponent);
  }

  void _setNewTargetWord() {
    if (_activeWords.isEmpty) {
      onGameFinished(true); // No more words to tap, player wins
      return;
    }
    _currentTargetWord = _activeWords[_random.nextInt(_activeWords.length)];
    _targetWordText?.text = 'Target: $_currentTargetWord!';
  }

  Color _generateReadableColor() {
    return HSLColor.fromAHSL(
      1.0,
      _random.nextDouble() * 360,
      0.7 + _random.nextDouble() * 0.3,
      0.6 + _random.nextDouble() * 0.2,
    ).toColor();
  }

  GameStatus _internalGameStatus = GameStatus.initial;

  @override
  void update(double dt) {
    // Guard against update logic running before onLoad is complete.
    if (!isLoaded) {
      return;
    }
    super.update(dt);

    if (gameStatusNotifier.value != _internalGameStatus) {
      _internalGameStatus = gameStatusNotifier.value;
      if (_internalGameStatus == GameStatus.playing) {
        _startGame();
      } else if (_internalGameStatus == GameStatus.initial) {
        _resetGame();
      }
    }

    if (_internalGameStatus != GameStatus.playing) {
      return;
    }

    // Move and bounce words
    for (final component in children.whereType<WordComponent>()) {
      final velocity = _wordVelocities[component];
      if (velocity == null) continue;

      component.position += velocity * dt;

      // Bounce off edges
      if (component.position.x < 0) {
        component.position.x = 0;
        velocity.x *= -1;
      } else if (component.position.x + component.size.x > size.x) {
        component.position.x = size.x - component.size.x;
        velocity.x *= -1;
      }

      if (component.position.y < 0) {
        component.position.y = 0;
        velocity.y *= -1;
      } else if (component.position.y + component.size.y > size.y) {
        component.position.y = size.y - component.size.y;
        velocity.y *= -1;
      }
    }
  }
}