import 'package:flame_based_games/features/raining_words_game/domain/entities/raining_word.dart';
import 'package:flame_based_games/features/raining_words_game/domain/repositories/raining_words_repository.dart';

class GetRainingWordsUseCase {
  final RainingWordsRepository repository;

  GetRainingWordsUseCase(this.repository);

  Future<List<RainingWord>> call(List<String> wordList) async {
    return await repository.getFlyingWords(wordList);
  }
}
