import 'package:equatable/equatable.dart';

class RainingWord extends Equatable {
  final String text;
  final String id;

  const RainingWord({
    required this.text,
    required this.id,
  });

  @override
  List<Object?> get props => [text, id];
}
