import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_based_games/core/games/domain/entities/mirapp_flame_game.dart';
import 'package:flame_based_games/core/games/domain/enums/game_status.dart';
import 'package:flame_based_games/features/bouncing_words_game/domain/entities/bouncing_words_game_parameters.dart';
import 'package:flutter/material.dart';

import 'bouncing_word_component.dart';

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

  TextComponent? _targetWordText;
  String? _currentTargetWord;
  final List<String> _activeWords = [];

  BouncingWordsGame({required super.levelConfig});

  @override
  Future<void> onLoad() async {
    // Initialize all synchronous variables first.
    _gameParameters = levelConfig.bouncingWordsGameParameters ?? const BouncingWordsGameParameters(wordPool: []);

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

    await super.onLoad();

    // Add components to the tree after awaiting.
    camera.viewport.add(_targetWordText!);
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
    removeAll(children.whereType<BouncingWordComponent>());
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

    final bouncingWord = BouncingWordComponent(
      word: word,
      onTapped: _onWordTapped,
      velocity: velocity,
      color: _generateReadableColor(),
    );
    bouncingWord.position = initialPosition;
    add(bouncingWord);
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

  void _onWordTapped(String tappedWord) {
    if (tappedWord == _currentTargetWord) {
      _scoreNotifier.value++;
      _activeWords.remove(tappedWord);

      if (_scoreNotifier.value >= _gameParameters.targetScore) {
        onGameFinished(true);
      } else {
        _setNewTargetWord();
      }
    } else {
      _mistakesNotifier.value++;
    }
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
  }
}