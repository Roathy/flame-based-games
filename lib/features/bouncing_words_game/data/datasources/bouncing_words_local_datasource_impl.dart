import 'package:flame_based_games/features/bouncing_words_game/domain/entities/sentence.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'bouncing_words_local_datasource.dart';

class BouncingWordsLocalDataSourceImpl implements BouncingWordsLocalDataSource {
  @override
  Future<List<String>> getDistractorWords() async {
    final fileContent = await rootBundle.loadString('lib/features/bouncing_words_game/docs/distractor_words_only.md');
    final lines = fileContent.split('\n');
    final words = <String>[];
    for (final line in lines) {
      if (line.startsWith('##') || line.trim().isEmpty) {
        continue;
      }
      words.addAll(line.split(',').map((e) => e.trim()));
    }
    return words;
  }

  @override
  Future<List<Sentence>> getSentences() async {
    final fileContent = await rootBundle.loadString('lib/features/bouncing_words_game/docs/listening_sentences_cefr.csv');
    final lines = fileContent.split('\n');
    final sentences = <Sentence>[];
    // Skip header
    for (int i = 1; i < lines.length; i++) {
      final line = lines[i];
      if (line.trim().isEmpty) {
        continue;
      }
      final fields = line.split(',');
      if (fields.length >= 4) {
        sentences.add(Sentence(
          category: fields[1].trim(),
          text: fields[2].trim(),
          words: fields[3].split('|').map((e) => e.trim()).toList(),
        ));
      }
    }
    return sentences;
  }
}
