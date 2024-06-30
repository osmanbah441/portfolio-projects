import 'package:equatable/equatable.dart';

import 'domain_models.dart';

class MenuItemListPage extends Equatable {
  const MenuItemListPage({
    required this.isLastPage,
    required this.productList,
  });

  final bool isLastPage;
  final List<MenuItem> productList;

  @override
  List<Object?> get props => [
        isLastPage,
        productList,
      ];
}
