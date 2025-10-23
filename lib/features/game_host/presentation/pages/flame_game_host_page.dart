import 'package:collection/collection.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../../../../core/games/data/repositories/level_manager.dart';
import '../../../../core/games/domain/entities/game_level_config.dart';
import '../../../../core/games/domain/entities/mirapp_flame_game.dart';
import '../../../../core/games/domain/enums/flame_game_type.dart';
import '../../../tap_game/flame/tap_game.dart';

class FlameGameHostPage extends StatelessWidget {
  final String levelId;

  const FlameGameHostPage({super.key, required this.levelId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GameLevelConfig?>(
      future: Future.delayed(const Duration(milliseconds: 100), () => LevelManager.levels.firstWhereOrNull((level) => level.id == levelId)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(
              child: Text('Level not found!'),
            ),
          );
        }

        final levelConfig = snapshot.data!;
        final game = _createGame(levelConfig);

        return Scaffold(
          appBar: AppBar(
            title: Text(levelConfig.name),
          ),
          body: GameWidget(game: game),
        );
      },
    );
  }

  MirappFlameGame _createGame(GameLevelConfig config) {
    switch (config.gameType) {
      case FlameGameType.tapGame:
        return TapGame(levelConfig: config);
      default:
        throw UnimplementedError('Game type not implemented: ${config.gameType}');
    }
  }
}
