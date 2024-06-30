import 'package:intl/intl.dart';

import 'domain_models.dart';

enum OrderStatus { pending, ongoing, completed }

class Order {
  final int id;
  final int user;
  final dynamic deliveryCrew;
  final OrderStatus status; // Use OrderStatus enum
  final double total;
  final DateTime date;
  final List<OrderItem> orderItems;

  Order({
    required this.id,
    required this.user,
    this.deliveryCrew,
    required this.status,
    required this.total,
    required this.date,
    required this.orderItems,
  });
  String get getFormattedDate => DateFormat('d MMM y').format(date);

  factory Order.fromJson(Map<String, dynamic> json) {
    OrderStatus convertedStatus =
        OrderStatus.values.byName(json['status'] as String);

    return Order(
      id: json['id'] as int,
      user: json['user'] as int,
      deliveryCrew: json['delivery_crew'],
      status: convertedStatus,
      total: double.parse(json['total'] as String),
      date: DateTime.parse(json['date'] as String),
      orderItems: (json['order_items'] as List)
          .map((orderItem) => OrderItem.fromJson(orderItem))
          .toList(),
    );
  }
}

class OrderItem {
  final MenuItem menuItem;
  final int quantity;
  final double unitPrice;
  final double price;

  OrderItem({
    required this.menuItem,
    required this.quantity,
    required this.unitPrice,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItem: MenuItem.fromJson(json['menuitem']),
      quantity: json['quantity'] as int,
      unitPrice: double.parse(json['unit_price'] as String),
      price: double.parse(json['price'] as String),
    );
  }
}
