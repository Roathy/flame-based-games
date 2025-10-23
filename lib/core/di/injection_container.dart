
import 'package:get_it/get_it.dart';
import '../games/data/repositories/level_manager.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register services and repositories here
  sl.registerLazySingleton(() => LevelManager());
}
