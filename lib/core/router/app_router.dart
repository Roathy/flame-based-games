
import 'package:go_router/go_router.dart';
import '../../features/game_host/presentation/pages/flame_game_host_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/game/:levelId',
      builder: (context, state) => FlameGameHostPage(
        levelId: state.pathParameters['levelId']!,
      ),
    ),
  ],
);
