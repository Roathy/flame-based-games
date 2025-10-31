import 'package:flame_based_games/features/bouncing_words_game/domain/entities/sentence.dart';

abstract class BouncingWordsRepository {
  Future<List<String>> getDistractorWords();
  Future<List<Sentence>> getSentences();
}
