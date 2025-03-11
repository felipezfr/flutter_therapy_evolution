import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'app/features/auth/presentation/pages/auth_base_page.dart';
import 'app/features/auth/presentation/pages/login_page.dart';
import 'app/features/auth/presentation/pages/register_page.dart';
import 'app/features/auth/presentation/pages/welcome_page.dart';
import 'app/features/home/presentation/pages/filters_page.dart';
import 'app/features/home/presentation/pages/home_page.dart';

final router = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/filters',
      builder: (context, state) => const FiltersPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthBasePage(),
      routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: 'register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: 'welcome',
          builder: (context, state) => const WelcomePage(),
        ),
      ],
    ),
  ],
  redirect: (context, state) async {
    // bool isUserLoggedIn = await GetIt.I.get<SessionService>().isUserLoggedIn();
    // if (isUserLoggedIn) return '/home';
    return null;
  },
);
