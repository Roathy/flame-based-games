import 'package:equatable/equatable.dart';
import 'package:flame_based_games/features/bouncing_words_game/domain/entities/bouncing_words_game_parameters.dart';
import '../enums/difficulty.dart';
import '../enums/flame_game_type.dart';

class GameLevelConfig extends Equatable {
  final String id;
  final String name;
  final FlameGameType gameType;
  final Difficulty difficulty;
  final String instruction;
  final Map<String, dynamic> parameters;
  final BouncingWordsGameParameters? bouncingWordsGameParameters;

  const GameLevelConfig({
    required this.id,
    required this.name,
    required this.gameType,
    required this.difficulty,
    required this.instruction,
    this.parameters = const {},
    this.bouncingWordsGameParameters,
  });

  @override
  List<Object?> get props => [id, name, gameType, difficulty, instruction, parameters, bouncingWordsGameParameters];
}
