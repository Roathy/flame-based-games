import '../entities/raining_word.dart';

abstract class RainingWordsRepository {
  Future<List<RainingWord>> getFlyingWords(List<String> wordList);
}
