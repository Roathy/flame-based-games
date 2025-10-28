
import 'package:flame/components.dart';
import 'package:flame_based_games/core/games/domain/entities/mirapp_flame_game.dart';
import 'package:flutter/material.dart';

class TapGame extends MirappFlameGame {
  TapGame({required super.levelConfig});

  @override
  ValueNotifier<int> get scoreNotifier => ValueNotifier(0);

  @override
  ValueNotifier<int> get mistakesNotifier => ValueNotifier(0);

  @override
  ValueNotifier<int> get timeNotifier => ValueNotifier(0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final squareColor = int.parse(levelConfig.parameters['square_color'] as String);
    add(SquareComponent(color: squareColor));
  }
}

class SquareComponent extends PositionComponent {
  final int color;

  SquareComponent({required this.color}) : super(size: Vector2.all(100));

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Color(color);
    canvas.drawRect(size.toRect(), paint);
  }
}
