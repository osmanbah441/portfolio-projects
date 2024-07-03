import 'package:app/api/api.dart';
import 'package:app/domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/features.dart';

part 'scaffold_with_nav_bar.dart';
part 'path_constant.dart';

final class AppRouter {
  AppRouter(this._api);
  final Api _api;

  String? _redirectUserToAllowPaths(GoRouterState state) {
    final isSignupPath = state.fullPath == _PathConstants.signUpPath;
    if (isSignupPath) return null;
    if (!_api.isUserSignedIn) return _PathConstants.signInPath;

    if (_api.currentUser!.isDeliveryCrew &&
        !_PathConstants.isDeliveryCrewAllowPaths(state.fullPath)) {
      return _PathConstants.ordersListPath;
    }

    if (_api.currentUser!.isManager &&
        !_PathConstants.isManagerAllowPath(state.fullPath)) {
      return _PathConstants.menuItemListPath;
    }

    return null;
  }

  GoRouter get router => GoRouter(
        // debugLogDiagnostics: true,

        redirect: (context, state) => _redirectUserToAllowPaths(state),
        initialLocation: _PathConstants.menuItemListPath,
        routes: [
          _bottomNavigationRoute,
          _menuItemDetailsRoute,
          _orderDetailsRoute,
          _signInRoute,
          _signUpRoute,
          _createMenuItemPath,
          _editMenuItemPath,
        ],
      );

  ShellRoute get _bottomNavigationRoute {
    return ShellRoute(
      routes: [
        _menuItemListRoute,
        _shoppingCartRoute,
        _orderListRoute,
        _usersListRoutes,
      ],
      builder: (context, state, child) => ScaffoldWithNavBar(
        state: state,
        user: _api.currentUser!,
        child: child,
      ),
    );
  }

  GoRoute get _menuItemListRoute => GoRoute(
        path: _PathConstants.menuItemListPath,
        builder: (context, _) => MenuItemListScreen(
          api: _api,
          onCreateMenuItemTap: () =>
              context.go(_PathConstants.createMenuItemPath),
          onMenuItemSelected: (id) =>
              context.go(_PathConstants.menuItemDetailsPath(id)),
        ),
      );

  GoRoute get _menuItemDetailsRoute => GoRoute(
      path: _PathConstants.menuItemDetailsPath(),
      builder: (context, state) => MenuItemDetailsScreen(
            api: _api,
            onEditMenuItemTap: (id) =>
                context.go(_PathConstants.editMenuItemPath(id)),
            onBackButtonTap: () => context.go(_PathConstants.menuItemListPath),
            menuItemId: int.parse(
              state.pathParameters[_PathConstants.menuIdPathParamter]!,
            ),
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

  GoRoute get _usersListRoutes => GoRoute(
      path: _PathConstants.userListPath,
      builder: (context, state) => UserListScreen(api: _api));

  GoRoute get _createMenuItemPath => GoRoute(
        redirect: (context, state) {
          if (!_PathConstants.isCustomerAllowPath(
            state.path,
            _api.currentUser!.isManager,
          )) {
            return _PathConstants.menuItemListPath;
          }
          return null;
        },
        path: _PathConstants.createMenuItemPath,
        builder: (context, state) => CreateMenuItemScreen(
          api: _api,
          onBackButtonTap: () => context.go(_PathConstants.menuItemListPath),
          onEditSuccess: () {},
        ),
      );

  GoRoute get _editMenuItemPath => GoRoute(
        redirect: (context, state) {
          if (!_PathConstants.isCustomerAllowPath(
            state.path,
            _api.currentUser!.isManager,
          )) {
            return _PathConstants.menuItemListPath;
          }
          return null;
        },
        path: _PathConstants.editMenuItemPath(),
        builder: (context, state) {
          final id = int.parse(
            state.pathParameters[_PathConstants.menuIdPathParamter]!,
          );

          return EditMenuItemScreen(
            menuItemId: id,
            api: _api,
            onBackButtonTap: () =>
                context.go(_PathConstants.menuItemDetailsPath(id)),
            onEditSuccess: () {},
          );
        },
      );
}
