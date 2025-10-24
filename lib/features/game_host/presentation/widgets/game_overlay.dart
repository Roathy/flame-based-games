import 'package:flutter/material.dart';

class GameOverlay extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const GameOverlay({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: backgroundColor ?? Colors.black.withAlpha((255 * 0.7).round()), // Default translucent black
        child: Center(
          child: child,
        ),
      ),
    );
  }
}