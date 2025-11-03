
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class PortalEffectComponent extends PositionComponent {
  final Color particleColor;
  final double radius;
  final int particleCount;
  final double particleLifespan;
  final Duration? duration;
  final int numberOfCircles;
  final double speed;

  PortalEffectComponent({
    Vector2? position,
    this.particleColor = Colors.white,
    this.radius = 20.0,
    this.particleCount = 15,
    this.particleLifespan = 1.5,
    this.duration,
    this.numberOfCircles = 3,
    this.speed = 1.0,
  }) : super(position: position, anchor: Anchor.center);

  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    if (duration != null) {
      add(TimerComponent(
        period: duration!.inSeconds.toDouble(),
        onTick: removeFromParent,
      ));
    }

    final radiusStep = radius / numberOfCircles;

    for (int i = 0; i < numberOfCircles; i++) {
      final currentRadius = radius - (i * radiusStep);
      final direction = pow(-1, i).toDouble();
      final currentSpeed = speed * (1 - i / (numberOfCircles * 2));

      add(
        ParticleSystemComponent(
          particle: Particle.generate(
            count: (particleCount * (1 - i / (numberOfCircles + 1))).round(),
            lifespan: particleLifespan * (1 + i / numberOfCircles),
            generator: (j) {
              final angle = _random.nextDouble() * 2 * pi;
              final position = Vector2(cos(angle), sin(angle)) * currentRadius;
              final velocity =
                  Vector2(-position.y, position.x) * currentSpeed * direction;

              return AcceleratedParticle(
                position: position,
                speed: velocity,
                child: ComputedParticle(
                  renderer: (canvas, particle) {
                    final paint = Paint()
                      ..color = particleColor
                          .withAlpha((255 * (1.0 - particle.progress)).round());
                    canvas.drawCircle(
                        Offset.zero, 1 + (particle.progress * 3.0), paint);
                  },
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
