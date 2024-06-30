import 'package:equatable/equatable.dart';

import 'domain_models.dart';

class OrderListPage extends Equatable {
  const OrderListPage({
    required this.isLastPage,
    required this.orderList,
  });

  final bool isLastPage;
  final List<Order> orderList;

  @override
  List<Object?> get props => [
        isLastPage,
        orderList,
      ];
}
