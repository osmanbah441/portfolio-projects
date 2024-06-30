import 'dart:async';

import 'package:app/api/api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain_models/domain_models.dart';

part 'menu_item_details_state.dart';

class MenuItemDetailsCubit extends Cubit<MenuItemDetailsState> {
  MenuItemDetailsCubit({
    required this.menuItemId,
    required Api api,
  })  : _api = api,
        super(const MenuItemDetailsInProgress()) {
    _fetchMenuItemDetails();
  }

  final int menuItemId;
  final Api _api;

  Future<void> _fetchMenuItemDetails() async {
    try {
      final product = await _api.getMenuItemDetails(menuItemId);
      emit(MenuItemDetailsSuccess(product: product));
    } catch (error) {
      emit(const MenuItemDetailsFailure());
    }
  }

  Future<void> refetch() async {
    emit(const MenuItemDetailsInProgress());

    _fetchMenuItemDetails();
  }

  void favoriteMenuItem() async {
    await _executeMenuItemUpdateOperation(
      () => _api.favoriteMenuItem(menuItemId),
    );
  }

  void unfavoriteMenuItem() async {
    await _executeMenuItemUpdateOperation(
      () => _api.unfavoriteQuote(menuItemId),
    );
  }

  Future<void> _executeMenuItemUpdateOperation(
    Future<MenuItem> Function() updateMenuItem,
  ) async {
    try {
      final updatedQuote = await updateMenuItem();
      emit(
        MenuItemDetailsSuccess(product: updatedQuote),
      );
    } catch (error) {
      final lastState = state;
      if (lastState is MenuItemDetailsSuccess) {
        emit(
          MenuItemDetailsSuccess(
            product: lastState.product,
            productUpdateError: error,
          ),
        );
      }
    }
  }

  Future<void> addMenuItemToCart(MenuItem item) async {
    try {
      await _api.addToCart(item);
      emit(MenuItemDetailsSuccess(product: item));
    } catch (error) {
      final lastState = state;
      if (lastState is MenuItemDetailsSuccess) {
        emit(MenuItemDetailsSuccess(
          product: lastState.product,
          productCartError: error,
        ));
      }
    }
  }
}
