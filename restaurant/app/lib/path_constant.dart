part of 'routes.dart';

abstract final class _PathConstants {
  const _PathConstants._();

  static const menuIdPathParamter = 'menuId';
  static const orderIdPathParameter = 'orderId';

  static String get menuItemListPath => '/menu-items';

  static String get createMenuItemPath => '/create-menu-items';

  static String editMenuItemPath([int? menuItemId]) =>
      '/edit-menu-item/${menuItemId ?? ":$menuIdPathParamter"}';

  static String menuItemDetailsPath([int? productId]) =>
      '$menuItemListPath/${productId ?? ":$menuIdPathParamter"}';

  static String get shoppingCartPath => '/shoppings-cart';

  static String get ordersListPath => '/orders';

  static String orderDetailsPath([int? orderId]) =>
      '$ordersListPath/${orderId ?? ":$orderIdPathParameter"}';

  static String get signInPath => '/sign-in';

  static String get signUpPath => '/sign-up';

  static String get userListPath => '/users';

  static bool isDeliveryCrewAllowPaths(String? path) {
    if (path == null) return false;
    if (path.startsWith(ordersListPath)) return true;
    if (path == signInPath) return true;
    if (path == signUpPath) return true;
    return false;
  }

  static bool isManagerAllowPath(String? path) {
    if (path == null) return false;
    if (path == shoppingCartPath) return false;
    return true;
  }

  static bool isCustomerAllowPath(String? path, bool isManager) {
    if (path == null) return false;
    if (path.startsWith(menuItemListPath)) return true;
    if (path == shoppingCartPath) return true;
    if (path.startsWith(ordersListPath)) return true;
    if (path == signInPath) return true;
    if (path == signUpPath) return true;
    if (isManager) return true;
    return false;
  }
}
