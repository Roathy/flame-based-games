import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class WordComponent extends TextComponent with TapCallbacks {
  final String word;
  final VoidCallback onTapped;

  WordComponent({required this.word, required this.onTapped})
      : super(
          text: word,
          anchor: Anchor.center,
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

  @override
  void onTapDown(TapDownEvent event) {
    onTapped();
  }
}
