import 'dart:io';

import 'package:dio/dio.dart';
import '../domain_models/domain_models.dart';

part 'user_management.dart';
part 'menu_item_management.dart';
part 'cart_item_management.dart';
part 'order_item_management.dart';

final _dio = Dio(BaseOptions(
  baseUrl: 'http://127.0.0.1:8000',
  headers: {'Content-Type': 'application/json'},
));

final class Api {
  Api()
      : _user = _UserManagement(),
        _menuItem = _MenuItemManagement(),
        _cart = const _CartItemManagement(),
        _order = _OrderItemManagement() {
    _dio.setupDefaultInterceptor(_user.getUserAuthToken);
    // _dio.interceptors.add(LogInterceptor());
  }

  final _UserManagement _user;
  final _MenuItemManagement _menuItem;
  final _CartItemManagement _cart;
  final _OrderItemManagement _order;

  bool get isUserSignedIn => _user.isUserSignedIn;

  User? get currentUser => _user.currentUser;

  Future<void> signIn(String username, String password) =>
      _user.signIn(username, password);

  Future<void> signUp(String username, String email, String password) =>
      _user.signUp(username, email, password);

  Future<void> requestPasswordResetEmail(String email) =>
      _user.requestPasswordResetEmail(email);

  Future<List<User>> getDeliveryCrewUser() => _user.getDeliveryCrewUsers();

  Future<MenuItemListPage> getMenuItemListPage({
    required int page,
    MenuItemCategory? category,
    required String searchTerm,
  }) =>
      _menuItem.getMenuItemListPage(
          page: page, searchTerm: searchTerm, category: category);

  Future<MenuItem> getMenuItemDetails(int id) =>
      _menuItem.getMenuItemDetails(id);

  Future<List<Cart>> getCartItems() => _cart.getCartItems();

  Future<void> addToCart(MenuItem i) => _cart.addToCart(i);

  Future<void> clearCart() => _cart.clearCart();

  Future<OrderListPage> getOrderListPageByUser({String status = ''}) =>
      _order.getOrderListPageByUser(status: status);

  Future<Order> getOrder(int id) => _order.getOrder(id);

  Future<void> placeOrder() => _order.placeOrder();

// status 0 means not complete and 1 means completed
// if the delivery crew is not null
  Future<Order> updateOrderStatus(int orderId, int status) =>
      _order.updateOrderStatus(orderId, status);

  Future<Order> assignDeliveryCrew(int orderId, int userId) =>
      _order.assignDeliveryCrew(orderId, userId);
}

// handle exception that can occur for GET method to the following resources
// [menu-items, cart, orders]
Exception _handleExecptionsForGetMethod(DioException e) {
  return e.error is SocketException
      ? const TemporalServerDownException()
      : (e.response!.statusCode == 401)
          ? const UserAuthenticationRequiredException()
          : e;
}

extension on Dio {
  void setupDefaultInterceptor(Future<String?> Function() authToken) async {
    interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await authToken();
        if (token != null) {
          options.headers.addAll({
            "Authorization": "Token $token",
          });
        }
        return handler.next(options);
      },
    ));
  }
}
