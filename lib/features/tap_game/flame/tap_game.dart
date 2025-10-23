
import '../../../core/games/domain/entities/mirapp_flame_game.dart';

class TapGame extends MirappFlameGame {
  TapGame({required super.levelConfig, required super.onGameFinishedCallback});

  @override
  Future<void> onLoad() async {
    // Add your game logic here
  }

  @override
  void onGameFinished(bool success) {
    onGameFinishedCallback(success);
  }
}
