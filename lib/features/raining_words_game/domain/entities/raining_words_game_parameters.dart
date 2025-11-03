
import 'package:flame_based_games/core/games/domain/entities/base_game_parameters.dart';

class RainingWordsGameParameters extends BaseGameParameters {
  final List<String> wordList;
  final double speed;
  final String shufflingMethod;

  const RainingWordsGameParameters({
    required this.wordList,
    required this.speed,
    required this.shufflingMethod,
  });

  @override
  List<Object?> get props => [wordList, speed, shufflingMethod];
}
