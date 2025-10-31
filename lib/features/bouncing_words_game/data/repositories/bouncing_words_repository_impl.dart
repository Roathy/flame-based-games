import 'package:flame_based_games/features/bouncing_words_game/data/datasources/bouncing_words_local_datasource.dart';
import 'package:flame_based_games/features/bouncing_words_game/domain/entities/sentence.dart';
import 'package:flame_based_games/features/bouncing_words_game/domain/repositories/bouncing_words_repository.dart';

class BouncingWordsRepositoryImpl implements BouncingWordsRepository {
  final BouncingWordsLocalDataSource localDataSource;

  BouncingWordsRepositoryImpl({required this.localDataSource});

  @override
  Future<List<String>> getDistractorWords() {
    return localDataSource.getDistractorWords();
  }

  @override
  Future<List<Sentence>> getSentences() {
    return localDataSource.getSentences();
  }
}
