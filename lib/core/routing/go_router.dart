import 'package:foody/core/observers/auth_provider.dart';
import 'package:foody/core/routing/routes_url.dart';
import 'package:foody/features/auth/login.dart';
import 'package:foody/features/auth/register.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/home_page.dart';

class AppRouter {
  static GoRouter create(AuthProvider auth) {
    return GoRouter(
      initialLocation: RoutesUrl.home,
      refreshListenable: auth, // 🔥 key line
      redirect: (context, state) {
        if (!auth.initialized) return null;

        final loggedIn = auth.isAuthenticated;
        final goingToAuth =
            state.matchedLocation == RoutesUrl.login ||
            state.matchedLocation == RoutesUrl.register;

        // Not logged in → block private pages
        if (!loggedIn && !goingToAuth) {
          return RoutesUrl.login;
        }

        // Logged in → block auth pages
        if (loggedIn && goingToAuth) {
          return RoutesUrl.home;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: RoutesUrl.login,
          builder: (context, _) => const LoginPage(),
        ),
        GoRoute(
          path: RoutesUrl.register,
          builder: (context, _) => const RegisterPage(),
        ),
        GoRoute(
          path: RoutesUrl.home,
          builder: (context, _) => const HomePage(),
        ),
      ],
    );
  }
}
