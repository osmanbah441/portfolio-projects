import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/api.dart';
import '../../domain_models/domain_models.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({
    required Api api,
  })  : _api = api,
        super(CartStateInprogress()) {
    _fetchCartItems();
  }
  final Api _api;

  void _fetchCartItems() async {
    try {
      final cart = await _api.getCartItems();
      emit(CartStateSuccess(cartItems: cart));
    } on Exception catch (_) {
      rethrow;
    }
  }

  void refetch() {
    emit(CartStateInprogress());
    _fetchCartItems();
  }

  void placeOrder() async {
    await _api.placeOrder();
    _fetchCartItems();
  }
}
