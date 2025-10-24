
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_based_games/core/games/domain/enums/game_status.dart';

import '../../../core/games/domain/entities/mirapp_flame_game.dart';

class TapGame extends MirappFlameGame with TapCallbacks {
  TapGame({required super.levelConfig});

  late TextComponent _tapCountText;
  int _tapCount = 0;
  final int _requiredTaps = 5; // Example: 5 taps to win
  final double _gameDuration = 10.0; // Example: 10 seconds to play
  Timer? _gameTimer; // Timer from flame/components.dart

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final myTextStyle = TextStyle(fontSize: 48, color: const Color(0xFFFFFFFF));
    _tapCountText = TextComponent(
      text: 'Taps: $_tapCount',
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(style: myTextStyle as TextStyle?),
    );
    add(_tapCountText);
  }

  @override
  void onMount() {
    super.onMount();
    gameStatusNotifier.addListener(_gameStatusListener);
  }

  @override
  void onRemove() {
    gameStatusNotifier.removeListener(_gameStatusListener);
    _gameTimer?.stop(); // Use stop() for Flame's Timer
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

  void _startGame() {
    _resetGame(); // Ensure a clean start
    _gameTimer = Timer(_gameDuration, onTick: () {
      if (_tapCount >= _requiredTaps) {
        onGameFinished(true); // Win if enough taps
      } else {
        onGameFinished(false); // Lose if not enough taps
      }
    });
    _gameTimer?.start(); // Start the timer
    gameStatusNotifier.value = GameStatus.playing; // Confirm playing state
  }

  void _resetGame() {
    _tapCount = 0;
    _tapCountText.text = 'Taps: $_tapCount';
    _gameTimer?.stop(); // Use stop() for Flame's Timer
    _gameTimer = null;
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (gameStatusNotifier.value == GameStatus.playing) {
      _tapCount++;
      _tapCountText.text = 'Taps: $_tapCount';
      if (_tapCount >= _requiredTaps) {
        onGameFinished(true); // Win immediately if required taps reached
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _gameTimer?.update(dt);
  }

}
