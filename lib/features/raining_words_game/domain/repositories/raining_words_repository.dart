import '../entities/raining_word.dart';

abstract class RainingWordsRepository {
  Future<List<RainingWord>> getRainingWords(List<String> wordList);
}
