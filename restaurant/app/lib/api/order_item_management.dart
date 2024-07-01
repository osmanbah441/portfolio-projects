part of 'api.dart';

class _OrderItemManagement {
  Future<OrderListPage> getOrderListPageByUser({String status = ''}) async {
    try {
      final response = await _dio.get(
        '/api/orders',
        queryParameters: {if (status.isNotEmpty) 'status': status},
      );
      final orders = response.data as List;
      return OrderListPage(
        isLastPage: true,
        orderList: orders.map((e) => Order.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      throw _handleExecptionsForGetMethod(e);
    }
  }

  Future<Order> getOrder(int id) async {
    final response = await _dio.get('/api/orders/$id');
    final order = response.data as Map<String, dynamic>;
    return Order.fromJson(order);
  }

  Future<void> placeOrder() async => await _dio.post('/api/orders');
}
