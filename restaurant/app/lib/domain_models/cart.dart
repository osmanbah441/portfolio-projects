import 'package:equatable/equatable.dart';

import 'domain_models.dart';

class Cart extends Equatable {
  const Cart({
    required this.menuItem,
    required this.quantity,
    required this.price,
    required this.unitPrice,
  });
  final MenuItem menuItem;
  final int quantity;
  final double price, unitPrice;

  Cart copyWith(int quantity) => Cart(
        menuItem: menuItem,
        quantity: quantity,
        price: price,
        unitPrice: unitPrice,
      );

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        menuItem: MenuItem.fromJson(json['menuitem']),
        quantity: json['quantity'],
        price: double.parse(json['price']),
        unitPrice: double.parse(json['unit_price']),
      );

  @override
  List<Object?> get props => [
        unitPrice,
        menuItem,
        quantity,
        price,
      ];
}
