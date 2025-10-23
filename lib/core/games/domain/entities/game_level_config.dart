import 'package:equatable/equatable.dart';
import '../enums/difficulty.dart';
import '../enums/flame_game_type.dart';

class GameLevelConfig extends Equatable {
  final String id;
  final String name;
  final FlameGameType gameType;
  final Difficulty difficulty;
  final String instruction;
  final Map<String, dynamic> parameters;

  const GameLevelConfig({
    required this.id,
    required this.name,
    required this.gameType,
    required this.difficulty,
    required this.instruction,
    required this.parameters,
  });

  @override
  List<Object?> get props => [id, name, gameType, difficulty, instruction, parameters];
}
