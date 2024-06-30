import 'package:dio/dio.dart';
import '../domain_models/domain_models.dart';
import 'user_secure_storage.dart';

final class Api {
  Api()
      : _secureStorage = UserSecureStorage(),
        _dio = Dio(BaseOptions(
          baseUrl: 'http://127.0.0.1:8000',
          headers: {'Content-Type': 'application/json'},
        )) {
    _dio.setupDefaultInterceptor(_secureStorage.getUserAuthToken);

    // _dio.interceptors.add(LogInterceptor());
  }

  final Dio _dio;
  final UserSecureStorage _secureStorage;

  bool get isUserSignedIn => _secureStorage.isUserSignedIn;

  User? get currentUser => _secureStorage.getCurrentUser();

  Future<void> _fetchCurrentUser() async {
    try {
      final response = await _dio.get('/api/users/me');
      final user = User.fromJson(response.data as Map<String, dynamic>);
      await _secureStorage.setCurrentUser(user);
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<void> signIn(String username, String password) async {
    final data = {
      'username': username,
      'password': password,
    };

    try {
      final response = await _dio.post('/token/login', data: data);
      await _secureStorage.setUserAuthToken(response.data['auth_token']);
      await _fetchCurrentUser();
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<void> signUp(String username, String email, String password) async {
    final data = {
      'username': username,
      'email': email,
      'password': password,
    };

    try {
      await _dio.post('/api/users/', data: data);
      await signIn(username, password);
    } catch (e) {
      rethrow;
    }
  }

  requestPasswordResetEmail(String value) {}

  Future<MenuItemListPage> getMenuItemListPage({
    required int page,
    MenuItemCategory? category,
    required String searchTerm,
  }) async {
    try {
      final response = await _dio.get(
        '/api/menu-items',
        queryParameters: {
          if (searchTerm.isNotEmpty) 'search': searchTerm,
          if (category != null) 'category': category.name,
        },
      );
      var data = response.data as List;
      return (data.isEmpty)
          ? const MenuItemListPage(isLastPage: true, productList: [])
          : MenuItemListPage(
              isLastPage: true,
              productList: data.map((e) => MenuItem.fromJson(e)).toList(),
            );
    } on DioException catch (e) {
      throw (e.response!.statusCode == 401)
          ? const UserAuthenticationRequiredException()
          : e;
    }
  }

  Future<MenuItem> getMenuItemDetails(int id) async {
    try {
      final response = await _dio.get('/api/menu-items/$id');
      return MenuItem.fromJson(response.data);
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<List<Cart>> getCartItems() async {
    try {
      final response = await _dio.get('/api/cart/menu-items');
      final cartItems = response.data as List;
      return cartItems.map((e) => Cart.fromJson(e)).toList();
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<void> addToCart(MenuItem i) async => await _dio.post(
        '/api/cart/menu-items',
        data: {'menuitem_id': i.id},
      );

  Future<void> clearCart() async => await _dio.delete('/api/cart/menu-items');

  Future<MenuItem> favoriteMenuItem(int id) async {
    throw UnimplementedError();
  }

  Future<MenuItem> unfavoriteQuote(int id) async {
    throw UnimplementedError();
  }

  Stream getUserStream() => Stream.value(null);

  getUserOrderById(String orderId, String s) {}

  Future<OrderListPage> getOrderListPageByUser({String status = ''}) async {
    final response = await _dio.get('/api/orders',
        queryParameters: {if (status.isNotEmpty) 'status': status});
    final orders = response.data as List;
    return OrderListPage(
        isLastPage: true,
        orderList: orders.map((e) => Order.fromJson(e)).toList());
  }

  Future<Order> getOrder(int id) async {
    final response = await _dio.get('/api/orders/$id');
    final order = response.data as Map<String, dynamic>;
    return Order.fromJson(order);
  }

  Future<void> placeOrder() async => await _dio.post('/api/orders');
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
