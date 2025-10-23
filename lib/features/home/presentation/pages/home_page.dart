
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/games/data/repositories/level_manager.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levels = LevelManager.levels;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Activities'),
      ),
      body: Column(
        children: [
          GameActivityButton(
            title: 'Flying Words',
            onPressed: () {
              GoRouter.of(context).go('/game/2');
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
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
