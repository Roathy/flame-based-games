import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class WordComponent extends TextComponent with TapCallbacks {
  final String word;
  final VoidCallback onTapped;
  final double speed;
  final Color color;

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
