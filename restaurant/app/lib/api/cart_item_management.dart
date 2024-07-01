part of 'api.dart';

class _CartItemManagement {
  const _CartItemManagement();
  Future<List<Cart>> getCartItems() async {
    try {
      final response = await _dio.get('/api/cart/menu-items');
      final cartItems = response.data as List;
      return cartItems.map((e) => Cart.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleExecptionsForGetMethod(e);
    }
  }

  Future<void> addToCart(MenuItem i) async => await _dio.post(
        '/api/cart/menu-items',
        data: {'menuitem_id': i.id},
      );

  Future<void> clearCart() async => await _dio.delete('/api/cart/menu-items');
}
