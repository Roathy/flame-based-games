import 'package:equatable/equatable.dart';

class Sentence extends Equatable {
  final String category;
  final String text;
  final List<String> words;

  const Sentence({
    required this.category,
    required this.text,
    required this.words,
  });

  @override
  List<Object?> get props => [category, text, words];
}
