
import 'package:flame_based_games/core/games/domain/entities/base_game_parameters.dart';
import 'package:flutter/material.dart';

class TapGameParameters extends BaseGameParameters {
  final Color squareColor;

  const TapGameParameters({required this.squareColor});

  @override
  List<Object?> get props => [squareColor];
}
