import 'package:flame_based_games/features/raining_words_game/domain/entities/raining_word.dart';

abstract class RainingWordsLocalDataSource {
  Future<List<RainingWord>> getFlyingWords(List<String> wordList);
}

class RainingWordsLocalDataSourceImpl implements RainingWordsLocalDataSource {
  @override
  Future<List<RainingWord>> getFlyingWords(List<String> wordList) async {
    // Simulate fetching words, for now just convert strings to FlyingWord entities
    return wordList.map((word) => RainingWord(text: word, id: word)).toList();
  }
}
