import 'package:go_router/go_router.dart';
import '../presentation/detail/view/detail_screen.dart';
import '../presentation/home/view/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: '/pokemon/:id',
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 1;
            return DetailScreen(id: id);
          },
        ),
      ],
    ),
  ],
);
