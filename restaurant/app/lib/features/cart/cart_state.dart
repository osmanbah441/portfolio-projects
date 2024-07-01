part of 'cart_cubit.dart';

sealed class CartState {
  const CartState();
}

class CartStateInprogress extends CartState {}

class CartStateFailure extends CartState {
  const CartStateFailure({required this.error});

  final dynamic error;
}

class CartStateSuccess extends CartState {
  const CartStateSuccess({required this.cartItems, this.cartUpdateError});

  final List<Cart> cartItems;
  final dynamic cartUpdateError;

  const CartStateSuccess.noItemsFound()
      : this(cartItems: const [], cartUpdateError: null);
}
