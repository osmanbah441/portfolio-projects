import 'package:app/api/api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/features.dart';

final class AppRouter {
  AppRouter(this._api);
  final Api _api;

  GoRouter get router => GoRouter(
        // debugLogDiagnostics: true,
        redirect: (context, state) {
          final isSignupPath = state.fullPath == _PathConstants.signUpPath;
          if (!_api.isUserSignedIn && !isSignupPath) {
            return _PathConstants.signInPath;
          }
          return null;
        },
        initialLocation: _PathConstants.orderDetailsPath(1),
        routes: [
          _bottomNavigationRoute,
          _menuItemDetailsRoute,
          _orderDetailsRoute,
          _signInRoute,
          _signUpRoute
        ],
      );

  ShellRoute get _bottomNavigationRoute => ShellRoute(
          routes: [
            _menuItemListRoute,
            _shoppingCartRoute,
            _orderListRoute,
          ],
          builder: (context, state, child) => ScaffoldWithNavBar(
                state: state,
                child: child,
              ));

  GoRoute get _menuItemListRoute => GoRoute(
        path: _PathConstants.menuItemListPath,
        builder: (context, _) => MenuItemListScreen(
          api: _api,
          onMenuItemSelected: (id) =>
              context.go(_PathConstants.menuItemDetailsPath(id)),
        ),
      );

  GoRoute get _menuItemDetailsRoute => GoRoute(
      path: _PathConstants.menuItemDetailsPath(),
      builder: (context, state) => MenuItemDetailsScreen(
            api: _api,
            onBackButtonTap: () => context.go(_PathConstants.menuItemListPath),
            menuItemId: int.parse(
                state.pathParameters[_PathConstants.menuIdPathParamter]!),
            onCartIconTap: () => context.go(_PathConstants.shoppingCartPath),
          ));

  GoRoute get _shoppingCartRoute => GoRoute(
        path: _PathConstants.shoppingCartPath,
        builder: (context, __) => CartScreen(
          onItemTap: (id) => context.go(_PathConstants.menuItemDetailsPath(id)),
          api: _api,
        ),
      );

  GoRoute get _orderListRoute => GoRoute(
        path: _PathConstants.ordersListPath,
        builder: (context, __) => OrderListScreen(
          api: _api,
          onOrderSelected: (id) =>
              context.go(_PathConstants.orderDetailsPath(id)),
        ),
      );

  GoRoute get _orderDetailsRoute => GoRoute(
        path: _PathConstants.orderDetailsPath(),
        builder: (context, state) => OrderDetailsScreen(
          api: _api,
          orderId: int.parse(
              state.pathParameters[_PathConstants.orderIdPathParameter]!),
          onBackButtonTap: () => context.go(_PathConstants.ordersListPath),
        ),
      );

  GoRoute get _signInRoute => GoRoute(
        path: _PathConstants.signInPath,
        builder: (context, state) => SignInScreen(
          userRepository: _api,
          onSignInSuccess: () => context.go(_PathConstants.menuItemListPath),
          onSignUpTap: () => context.go(_PathConstants.signUpPath),
          onForgotPasswordTap: () => showDialog(
            context: context,
            builder: (context) => ForgotMyPasswordDialog(
              api: _api,
            ),
          ),
        ),
      );

  GoRoute get _signUpRoute => GoRoute(
        path: _PathConstants.signUpPath,
        builder: (context, state) => SignUpScreen(
          userRepository: _api,
          onSignUpSuccess: () => context.go(_PathConstants.menuItemListPath),
          onSignInTap: () => context.go(_PathConstants.signInPath),
        ),
      );
}

abstract final class _PathConstants {
  const _PathConstants._();

  static const menuIdPathParamter = 'menuId';
  static const orderIdPathParameter = 'orderId';

  static String get rootPath => '/';

  static String get menuItemListPath => '${rootPath}menu-items';

  static String menuItemDetailsPath([int? productId]) =>
      '$menuItemListPath/${productId ?? ":$menuIdPathParamter"}';

  static String get shoppingCartPath => '${rootPath}shoppings-cart';

  static String get ordersListPath => '${rootPath}orders';

  static String orderDetailsPath([int? orderId]) =>
      '$ordersListPath/${orderId ?? ":$orderIdPathParameter"}';

  static String get signInPath => '${rootPath}sign-in';

  static String get signUpPath => '${rootPath}sign-up';
}

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar(
      {super.key, required this.child, required this.state});

  final Widget child;
  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: (state.fullPath == _PathConstants.shoppingCartPath)
              ? 1
              : (state.fullPath == _PathConstants.ordersListPath)
                  ? 2
                  : 0,
          onDestinationSelected: (index) => (index == 1)
              ? context.go(_PathConstants.shoppingCartPath)
              : (index == 2)
                  ? context.go(_PathConstants.ordersListPath)
                  : context.go(_PathConstants.menuItemListPath),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.travel_explore), label: 'explore'),
            NavigationDestination(
                icon: Icon(Icons.shopping_cart), label: 'cart'),
            NavigationDestination(
                icon: Icon(Icons.manage_history_outlined), label: 'history'),
          ],
        ),
        body: child,
      ),
    );
  }
}
