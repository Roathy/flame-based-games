import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class FadingTextComponent extends TextComponent implements OpacityProvider {
  double _opacity = 1.0;

  FadingTextComponent({
    required super.text,
    required super.textRenderer,
    super.position,
    super.anchor,
  });

  @override
  double get opacity => _opacity;

  @override
  set opacity(double value) {
    _opacity = value;
    final originalStyle = (textRenderer as TextPaint).style;
    textRenderer = TextPaint(
      style: originalStyle.copyWith(
        color: originalStyle.color?.withOpacity(value),
      ),
    );
  }
}
