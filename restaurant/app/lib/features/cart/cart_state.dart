part of 'cart_cubit.dart';

sealed class CartState {
  const CartState();
}

class CartStateInprogress extends CartState {}

class CartStateFailure extends CartState {}

class CartStateSuccess extends CartState {
  const CartStateSuccess({required this.cartItems, this.cartUpdateError});

  final List<Cart> cartItems;
  final dynamic cartUpdateError;

  const CartStateSuccess.noItemsFound()
      : this(cartItems: const [], cartUpdateError: null);
}
