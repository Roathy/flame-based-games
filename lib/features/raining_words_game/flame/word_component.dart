import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/particles.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class WordComponent extends TextComponent with TapCallbacks {
  final String word;
  final VoidCallback onTapped;
  final double speed;
  final Color color;
  bool animationTriggered = false;

  WordComponent({
    required this.word,
    required this.onTapped,
    required this.speed,
    required this.color,
  }) : super(
          text: word,
          anchor: Anchor.center,
          textRenderer: TextPaint(
            style: TextStyle(
              color: color,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

  void shake() {
    final originalPosition = position.clone();
    add(SequenceEffect(
      [
        MoveEffect.by(Vector2(-5, 0), EffectController(duration: 0.05)),
        MoveEffect.by(Vector2(10, 0), EffectController(duration: 0.05)),
        MoveEffect.by(Vector2(-10, 0), EffectController(duration: 0.05)),
        MoveEffect.by(Vector2(5, 0), EffectController(duration: 0.05)),
        // Return to original position
        MoveEffect.to(originalPosition, EffectController(duration: 0.05)),
      ],
      onComplete: () {
        // Ensure it ends exactly at the original position
        position.setFrom(originalPosition);
      },
    ));
  }

  void bounceAndDisappear() {
    final random = Random();
    final bounceHeight = -50.0; // A more noticeable bounce height
    final horizontalDisappearDistance = 400.0; // How far it moves horizontally
    final verticalDisappearDistance = 300.0; // How far it moves downwards after bounce

    // Randomly choose to disappear left or right
    final horizontalDirection = random.nextBool() ? 1 : -1;

    add(SequenceEffect(
      [
        // Initial bounce up
        MoveEffect.by(Vector2(0, bounceHeight), EffectController(duration: 0.3, curve: Curves.easeOutQuad)),
        // Move off-screen horizontally and downwards
        MoveEffect.by(
          Vector2(horizontalDirection * horizontalDisappearDistance, verticalDisappearDistance),
          EffectController(duration: 1.0, curve: Curves.easeInCubic),
        ),
      ],
      onComplete: () {
        removeFromParent();
      },
    ));
  }

  @override
  void onTapDown(TapDownEvent event) {
    _explode();
    onTapped();
  }

  void _explode() {
    final random = Random();
    parent?.add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: 20,
          lifespan: 0.3,
          generator: (i) => AcceleratedParticle(
            speed: Vector2(
                  random.nextDouble() * 400 - 200,
                  random.nextDouble() * 400 - 200,
                ) *
                (1 - (random.nextDouble() * 0.5)),
            child: CircleParticle(
              radius: 2 + random.nextDouble() * 2,
              paint: Paint()..color = color,
            ),
          ),
        ),
      ),
    );
  }
}
