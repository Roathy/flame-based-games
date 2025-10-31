

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class BouncingWordComponent extends PositionComponent with TapCallbacks, HasGameReference {
  final String word;
  final Function(String) onTapped;
  Vector2 velocity;
  final Color color;

  late TextComponent _textComponent;
  bool _animationTriggered = false;

  BouncingWordComponent({
    required this.word,
    required this.onTapped,
    required this.velocity,
    required this.color,
  }) : super(size: Vector2(100, 20)); // Initial size, will be updated by text component

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _textComponent = TextComponent(
      text: word,
      textRenderer: TextPaint(
        style: TextStyle(
          color: color,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(_textComponent);

    // Update component size based on text size
    size = _textComponent.size;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    // Bounce off edges
    if (position.x < 0) {
      position.x = 0;
      velocity.x *= -1;
    } else if (position.x + size.x > game.size.x) {
      position.x = game.size.x - size.x;
      velocity.x *= -1;
    }

    if (position.y < 0) {
      position.y = 0;
      velocity.y *= -1;
    } else if (position.y + size.y > game.size.y) {
      position.y = game.size.y - size.y;
      velocity.y *= -1;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!_animationTriggered) {
      _animationTriggered = true;
      onTapped(word);
      removeFromParent();
    }
  }
}
