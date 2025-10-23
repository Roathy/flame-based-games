
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame_based_games/core/di/injection_container.dart';
import '../../domain/services/greeting_service.dart';

final greetingProvider = Provider<String>((ref) {
  final greetingService = sl<GreetingService>();
  return greetingService.greeting;
});
