import 'package:foody/core/models/restaurant.dart';
import 'package:foody/core/observers/auth_provider.dart';
import 'package:foody/core/routing/routes_url.dart';
import 'package:foody/features/auth/login.dart';
import 'package:foody/features/auth/register.dart';
import 'package:foody/features/cart/screen/cart_screen.dart';
import 'package:foody/features/deliveries/deliveries.dart';
import 'package:foody/features/home/screen/shell_navigation.dart';
import 'package:foody/features/menus/screen/menu_screen.dart';
import 'package:foody/features/orders/orders.dart';
import 'package:foody/features/profile/profile.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/screen/home_page.dart';

class AppRouter {
  static GoRouter create(AuthProvider auth) {
    return GoRouter(
      initialLocation: auth.isAuthenticated ? RoutesUrl.home : RoutesUrl.login,
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
          path: RoutesUrl.cart,
          builder: (context, _) => const CartScreen(),
        ),
        GoRoute(
          path: RoutesUrl.menus,
          builder: (context, state) {
            {
              return MenuScreen(restaurant: state.extra as Restaurant);
            }
          },
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ShellNavigation(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              preload: true,
              routes: [
                GoRoute(
                  path: RoutesUrl.home,
                  builder: (context, state) {
                    return HomePage();
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              preload: true,
              routes: [
                GoRoute(
                  path: RoutesUrl.orders,
                  builder: (context, state) {
                    return Orders();
                  },
                ),
              ],
            ),

            StatefulShellBranch(
              preload: true,
              routes: [
                GoRoute(
                  path: RoutesUrl.deliveries,
                  builder: (context, state) {
                    return Deliveries();
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              preload: true,
              routes: [
                GoRoute(
                  path: RoutesUrl.profile,
                  builder: (context, state) {
                    return Profile();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
