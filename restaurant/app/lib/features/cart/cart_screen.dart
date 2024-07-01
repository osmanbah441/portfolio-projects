import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../api/api.dart';
import '../../domain_models/domain_models.dart';
import '../../component_library/component_library.dart';
import 'cart_cubit.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    required this.api,
    required this.onItemTap,
    super.key,
  });

  final Api api;

  final Function(int) onItemTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartCubit>(
      create: (_) => CartCubit(api: api),
      child: CartView(
        onItemTap: onItemTap,
      ),
    );
  }
}

@visibleForTesting
class CartView extends StatelessWidget {
  const CartView({
    super.key,
    required this.onItemTap,
  });

  final Function(int) onItemTap;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        final cartUpdateError =
            state is CartStateSuccess ? state.cartUpdateError : null;
        if (cartUpdateError != null) {
          final snackBar =
              cartUpdateError is UserAuthenticationRequiredException
                  ? const AuthenticationRequiredErrorSnackBar()
                  : const GenericErrorSnackBar();

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Feast Assembly'),
            leading: const Icon(Icons.food_bank_outlined),
          ),
          body: SafeArea(
              child: switch (state) {
            CartStateInprogress() => const CenteredCircularProgressIndicator(),
            CartStateSuccess() => _Cart(state.cartItems, onItemTap),
            CartStateFailure() => state.error is TemporalServerDownException
                ? ExceptionIndicator.serverDown(
                    onTryAgain: () {
                      final cubit = context.read<CartCubit>();
                      cubit.refetch();
                    },
                  )
                : ExceptionIndicator(
                    onTryAgain: () {
                      final cubit = context.read<CartCubit>();
                      cubit.refetch();
                    },
                  ),
          }),
        );
      },
    );
  }
}

class _Cart extends StatelessWidget {
  const _Cart(this.cartItems, this.onItemTap);
  final List<Cart> cartItems;
  final Function(int) onItemTap;

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: (cartItems.isEmpty)
          ? const _EmptyCartList()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cart = cartItems[index];
                      return MenuItemQtyTile(
                        onItemTap: () => onItemTap(cart.menuItem.id),
                        imageUrl: cart.menuItem.imageUrl,
                        price: cart.price,
                        quantity: cart.quantity,
                        title: cart.menuItem.title,
                      );
                    },
                  ),
                ),
                ExpandedElevatedButton(
                    label: 'buy now',
                    onTap: () => showDialog(
                          context: context,
                          builder: (_) => OrderSummaryDialog(
                            totalPrice: 0,
                            totalQuantity: 0,
                            onOrderConfirmed: () {
                              cartCubit.placeOrder();
                              context.pop();
                            },
                          ),
                        ))
              ],
            ),
    );
  }
}

class _EmptyCartList extends StatelessWidget {
  const _EmptyCartList();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'No Cart Items found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          const Text('Your cart list is currently empty.')
        ],
      ),
    );
  }
}
