
import 'package:get_it/get_it.dart';
import 'package:flame_based_games/features/raining_words_game/data/datasources/raining_words_local_datasource.dart';
import 'package:flame_based_games/features/raining_words_game/data/repositories/raining_words_repository_impl.dart';
import 'package:flame_based_games/features/raining_words_game/domain/repositories/raining_words_repository.dart';
import 'package:flame_based_games/features/raining_words_game/domain/usecases/get_raining_words_usecase.dart';
import '../games/data/repositories/level_manager.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register services and repositories here
  sl.registerLazySingleton(() => LevelManager());

  // Flying Words Game
  sl.registerLazySingleton<RainingWordsLocalDataSource>(
    () => RainingWordsLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<RainingWordsRepository>(
    () => RainingWordsRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(
    () => GetRainingWordsUseCase(sl()),
  );
}
