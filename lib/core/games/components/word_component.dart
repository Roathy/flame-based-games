import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/particles.dart';
import 'package:flame/effects.dart';
import 'package:flame_based_games/core/games/components/fading_text_component.dart';
import 'package:flame_based_games/core/theme/flame_game_theme.dart';
import 'package:flutter/material.dart';
import 'package:flame_based_games/features/bouncing_words_game/flame/bouncing_words_game.dart';

class WordComponent extends TextComponent with TapCallbacks {
  final String word;
  final bool Function() onTapped;
  FlameGameTheme theme;
  bool animationTriggered = false;

  WordComponent({
    required this.word,
    required this.onTapped,
    required this.theme,
  }) : super(
          text: word,
          anchor: Anchor.center,
          textRenderer: TextPaint(
            style: theme.wordTextStyle,
          ),
        );

  void updateTheme(FlameGameTheme newTheme) {
    theme = newTheme;
    textRenderer = TextPaint(style: theme.wordTextStyle);
  }

  void shake({bool removeOnComplete = false}) {
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
        if (removeOnComplete) {
          removeFromParent();
        } else {
          // Ensure it ends exactly at the original position
          position.setFrom(originalPosition);
        }
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
    if (onTapped()) {
      explode();

      // Add +1 text animation
      final scoreIndicator = FadingTextComponent(
        text: '+1!',
        anchor: Anchor.center,
        position: position,
        textRenderer: TextPaint(
          style: theme.uiTextStyle.copyWith(color: theme.correctColor),
        ),
      );
      parent?.add(scoreIndicator);
      scoreIndicator.add(
        SequenceEffect([
          MoveEffect.by(Vector2(0, -20), EffectController(duration: 0.5)),
          OpacityEffect.to(0, EffectController(duration: 0.5)),
        ], onComplete: () => scoreIndicator.removeFromParent()),
      );

      removeFromParent();
    } else {
      shake(removeOnComplete: true);
    }
  }

  void explode() {
    if (parent is BouncingWordsGame) {
      (parent as BouncingWordsGame).add(
        (parent as BouncingWordsGame).createExplosionAnimation(
          position: position,
          color: theme.neutralColor,
          count: 15,
          lifespan: 0.4,
          speed: 250,
          particleRadius: 1.5,
        ),
      );
    } else {
      // Fallback for other game types if needed
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
                paint: Paint()..color = theme.neutralColor,
              ),
            ),
          ),
        ),
      );
    }
  }
}
