import 'package:flame_based_games/features/raining_words_game/data/datasources/raining_words_local_datasource.dart';
import 'package:flame_based_games/features/raining_words_game/domain/entities/raining_word.dart';
import 'package:flame_based_games/features/raining_words_game/domain/repositories/raining_words_repository.dart';

class RainingWordsRepositoryImpl implements RainingWordsRepository {
  final RainingWordsLocalDataSource localDataSource;

  RainingWordsRepositoryImpl({required this.localDataSource});

  @override
  Future<List<RainingWord>> getFlyingWords(List<String> wordList) async {
    return await localDataSource.getFlyingWords(wordList);
  }
}
