import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import 'package:flame/game.dart';
import 'package:flame_based_games/features/raining_words_game/flame/raining_words_game.dart';
import 'package:flutter/material.dart';
import '../../../../core/games/data/repositories/level_manager.dart';
import '../../../../core/games/domain/entities/game_level_config.dart';
import '../../../../core/games/domain/entities/mirapp_flame_game.dart';
import '../../../../core/games/domain/enums/flame_game_type.dart';
import '../../../../core/games/domain/enums/game_status.dart';
import '../../../tap_game/flame/tap_game.dart';
import '../widgets/game_overlay.dart';


import '../../../bouncing_words_game/flame/bouncing_words_game.dart';

class FlameGameHostPage extends StatefulWidget {
  final String levelId;

  const FlameGameHostPage({super.key, required this.levelId});

  @override
  State<FlameGameHostPage> createState() => _FlameGameHostPageState();
}

class _FlameGameHostPageState extends State<FlameGameHostPage> {
  MirappFlameGame? _game;
  GameLevelConfig? _levelConfig;
  final ValueNotifier<GameStatus> _gameStatusNotifier = ValueNotifier(GameStatus.initial);

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  Future<void> _loadGame() async {
    _levelConfig = await Future.delayed(
      const Duration(milliseconds: 100),
      () => LevelManager.levels.firstWhereOrNull(
        (level) => level.id == widget.levelId,
      ),
    );

    if (_levelConfig != null) {
      // Clean up listeners from the old game instance before creating a new one
      _game?.gameStatusNotifier.removeListener(_gameStatusListener);
      if (_game is BouncingWordsGame) {
        (_game as BouncingWordsGame).showCountdown.removeListener(_onShowCountdownChanged);
      }

      _game = _createGame(_levelConfig!);

      // Add listeners to the new game instance
      _game?.gameStatusNotifier.addListener(_gameStatusListener);
      if (_game is BouncingWordsGame) {
        (_game as BouncingWordsGame).showCountdown.addListener(_onShowCountdownChanged);
      }

      _gameStatusNotifier.value = GameStatus.initial;
    } else {
      _gameStatusNotifier.value = GameStatus.gameOver;
    }
    setState(() {});
  }

  void _onShowCountdownChanged() {
    final game = _game;
    if (game is BouncingWordsGame) {
      if (game.showCountdown.value) {
        game.overlays.add('countdown');
      } else {
        game.overlays.remove('countdown');
      }
    }
  }

  void _gameStatusListener() {
    if (_game != null) {
      _gameStatusNotifier.value = _game!.gameStatusNotifier.value;
    }
  }

  MirappFlameGame? _createGame(GameLevelConfig config) {
    try {
      switch (config.gameType) {
        case FlameGameType.tapGame:
          return TapGame(levelConfig: config);
        case FlameGameType.rainingWordsGame:
          return RainingWordsGame(levelConfig: config);
        case FlameGameType.bouncingWordsGame:
          return BouncingWordsGame(levelConfig: config);
        default:
          throw UnimplementedError(
            'Game type not implemented: \${config.gameType}',
          );
      }
    } catch (e) {
      // Log the error and update the status
      print('Error creating game: $e');
      _gameStatusNotifier.value = GameStatus.error;
      return null;
    }
  }

  @override
  void dispose() {
    _gameStatusNotifier.dispose();
    _game?.gameStatusNotifier.removeListener(_gameStatusListener);
    if (_game is BouncingWordsGame) {
      (_game as BouncingWordsGame).showCountdown.removeListener(_onShowCountdownChanged);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_levelConfig == null && _gameStatusNotifier.value != GameStatus.gameOver) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_levelConfig == null || _game == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Level not found!')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<String>(
          valueListenable: _game!.categoryNotifier,
          builder: (context, category, child) {
            return Text(category.isEmpty ? _levelConfig!.name : category, style: Theme.of(context).appBarTheme.titleTextStyle);
          },
        ),
        actions: [
          if (_game is RainingWordsGame)
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () {
                (_game as RainingWordsGame).replayCategoryAnnouncement();
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          GameWidget(
            game: _game!,
            overlayBuilderMap: {
              'countdown': (context, game) {
                return ValueListenableBuilder<int>(
                  valueListenable: (game as BouncingWordsGame).countdownNotifier,
                  builder: (context, value, child) {
                    return Center(
                      child: Text(
                        value.toString(),
                        style: const TextStyle(
                          fontSize: 120,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              },
            },
          ),
          Positioned(
            top: 10,
            right: 10,
            child: ValueListenableBuilder<int>(
              valueListenable: _game!.scoreNotifier,
              builder: (context, score, child) {
                return Text('Score: $score', style: const TextStyle(color: Colors.greenAccent, fontSize: 24));
              },
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: ValueListenableBuilder<int>(
              valueListenable: _game!.mistakesNotifier,
              builder: (context, mistakes, child) {
                return Text('Mistakes: $mistakes', style: const TextStyle(color: Colors.redAccent, fontSize: 24));
              },
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: ValueListenableBuilder<int>(
              valueListenable: _game!.timeNotifier,
              builder: (context, time, child) {
                return Text('Time: $time', style: const TextStyle(color: Colors.white, fontSize: 24));
              },
            ),
          ),
          ValueListenableBuilder<GameStatus>(
            valueListenable: _gameStatusNotifier,
            builder: (context, status, child) {
              switch (status) {
                case GameStatus.initial:
                  return _buildInitialScreen();
                case GameStatus.finished:
                case GameStatus.gameOver:
                  return _buildFinishedScreen();
                case GameStatus.error:
                  return _buildErrorScreen();
                case GameStatus.paused:
                  return _buildPausedScreen();
                case GameStatus.playing:
                  return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen() {
    return GameOverlay(
      child: AlertDialog(
        title: Text('Error', style: Theme.of(context).textTheme.headlineMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'An unexpected error occurred while loading the game.',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadGame,
              child: const Text('Retry'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialScreen() {
    return GameOverlay(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _gameStatusNotifier.value = GameStatus.playing;
                _game?.gameStatusNotifier.value = GameStatus.playing;
              },
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishedScreen() {
    return GameOverlay(
      child: AlertDialog(
        title: Text('Game Over!', style: Theme.of(context).textTheme.headlineMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _gameStatusNotifier.value == GameStatus.finished
                  ? 'Congratulations! You won!'
                  : 'Better luck next time!',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadGame,
              child: const Text('Play Again'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPausedScreen() {
    return GameOverlay(
      child: AlertDialog(
        title: Text('Game Paused', style: Theme.of(context).textTheme.headlineMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'The game is currently paused.',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _gameStatusNotifier.value = GameStatus.playing;
                _game?.gameStatusNotifier.value = GameStatus.playing;
              },
              child: const Text('Resume Game'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Exit Game'),
            ),
          ],
        ),
      ),
    );
  }
}