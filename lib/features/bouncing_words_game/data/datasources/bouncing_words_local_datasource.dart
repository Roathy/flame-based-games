import 'package:flame_based_games/features/bouncing_words_game/domain/entities/sentence.dart';

abstract class BouncingWordsLocalDataSource {
  Future<List<String>> getDistractorWords();
  Future<List<Sentence>> getSentences();
}
