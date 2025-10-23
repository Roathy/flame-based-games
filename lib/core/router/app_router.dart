
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/game_template/presentation/pages/game_template_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/game-template',
      builder: (context, state) => const GameTemplatePage(),
    ),
  ],
);
