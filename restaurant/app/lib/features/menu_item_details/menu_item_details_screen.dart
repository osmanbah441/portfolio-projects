import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/api.dart';
import '../../component_library/component_library.dart';
import '../../domain_models/domain_models.dart';
import 'menu_item_details_cubit.dart';

class MenuItemDetailsScreen extends StatelessWidget {
  const MenuItemDetailsScreen({
    required this.menuItemId,
    required this.onCartIconTap,
    required this.api,
    super.key,
    required this.onBackButtonTap,
  });

  final int menuItemId;
  final VoidCallback onCartIconTap, onBackButtonTap;
  final Api api;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MenuItemDetailsCubit>(
      create: (_) => MenuItemDetailsCubit(menuItemId: menuItemId, api: api),
      child: MenuItemDetailsView(
        onCartIconTap: onCartIconTap,
        onBackButtonTap: onBackButtonTap,
      ),
    );
  }
}

@visibleForTesting
class MenuItemDetailsView extends StatelessWidget {
  const MenuItemDetailsView({
    super.key,
    required this.onCartIconTap,
    required this.onBackButtonTap,
  });

  final VoidCallback onCartIconTap, onBackButtonTap;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MenuItemDetailsCubit, MenuItemDetailsState>(
      listener: (context, state) {
        final productUpdateError =
            state is MenuItemDetailsSuccess ? state.productUpdateError : null;
        final productCartError =
            state is MenuItemDetailsSuccess ? state.productCartError : null;

        if (productUpdateError != null) {
          final snackBar =
              productUpdateError is UserAuthenticationRequiredException
                  ? const AuthenticationRequiredErrorSnackBar()
                  : const GenericErrorSnackBar();

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);

          if (productUpdateError is UserAuthenticationRequiredException) {
            onCartIconTap();
          }
        }

        if (productCartError != null) {
          final snackBar =
              productCartError is UserAuthenticationRequiredException
                  ? const AuthenticationRequiredErrorSnackBar()
                  : const GenericErrorSnackBar();

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        final isSuccessState = state is MenuItemDetailsSuccess;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: isSuccessState
              ? AppBar(
                  foregroundColor: Colors.white,
                  leading: BackButton(onPressed: onBackButtonTap),
                  backgroundColor: Colors.transparent,
                  actions: [
                    IconButton(
                        onPressed: onCartIconTap,
                        icon: const Icon(Icons.shopping_cart))
                  ],
                )
              : null,
          body: switch (state) {
            MenuItemDetailsInProgress() =>
              const CenteredCircularProgressIndicator(),
            MenuItemDetailsSuccess() => _MenuItem(item: state.product),
            MenuItemDetailsFailure() => ExceptionIndicator(
                onTryAgain: () {
                  final cubit = context.read<MenuItemDetailsCubit>();
                  cubit.refetch();
                },
              ),
          },
          floatingActionButtonLocation:
              isSuccessState ? FloatingActionButtonLocation.centerFloat : null,
          floatingActionButton: isSuccessState
              ? _FloatingActionButton(menuItem: state.product)
              : null,
        );
      },
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton({required this.menuItem});

  final MenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ExpandedElevatedButton(
        icon: const Icon(Icons.shopping_cart),
        label: 'Add to Cart',
        onTap: () {
          context.read<MenuItemDetailsCubit>().addMenuItemToCart(menuItem);
        },
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.item,
  });

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            height: 350,
            width: double.infinity,
            item.imageUrl,
            fit: BoxFit.cover,
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            title: Text(
              item.title,
              style: textTheme.titleMedium,
            ),
            trailing: Text(
              item.price,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.description,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
