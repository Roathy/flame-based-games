
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/games/data/repositories/level_manager.dart';
import '../../../../core/games/domain/entities/game_level_config.dart';


class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flying Words', style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Column(
        children: [
          GameActivityButton(
            title: 'Flying Words (Random)',
            onPressed: () {
              final GameLevelConfig? rainingWordsLevel = LevelManager.levels.firstWhereOrNull(
                (level) => level.id == '2',
              );
              if (rainingWordsLevel != null) {
                context.push('/game/${rainingWordsLevel.id}');
              } else {
                // Optionally show an error or a message if the level is not found
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Raining Words game level not found!')),
                );
              }
            },
          ),
          GameActivityButton(
            title: 'Flying Words (Shuffle Bag)',
            onPressed: () {
              final GameLevelConfig? rainingWordsLevel = LevelManager.levels.firstWhereOrNull(
                (level) => level.id == '3',
              );
              if (rainingWordsLevel != null) {
                context.push('/game/${rainingWordsLevel.id}');
              } else {
                // Optionally show an error or a message if the level is not found
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Raining Words game level not found!')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class GameActivityButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const GameActivityButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 60.0,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}
