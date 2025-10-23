
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../flame/game.dart';

class GameTemplatePage extends StatelessWidget {
  const GameTemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Template'),
      ),
      body: GameWidget(game: TemplateGame()),
    );
  }
}
