
import 'package:get_it/get_it.dart';
import '../../features/home/domain/services/greeting_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register services and repositories here
  sl.registerLazySingleton(() => GreetingService());
}
