part of 'menu_item_details_cubit.dart';

sealed class MenuItemDetailsState extends Equatable {
  const MenuItemDetailsState();
}

class MenuItemDetailsInProgress extends MenuItemDetailsState {
  const MenuItemDetailsInProgress();

  @override
  List<Object?> get props => [];
}

class MenuItemDetailsSuccess extends MenuItemDetailsState {
  const MenuItemDetailsSuccess({
    required this.product,
    this.productUpdateError,
    this.productCartError,
  });

  final MenuItem product;
  final dynamic productUpdateError;
  final dynamic productCartError;

  @override
  List<Object?> get props => [
        product,
        productUpdateError,
        productCartError,
      ];
}

class MenuItemDetailsFailure extends MenuItemDetailsState {
  const MenuItemDetailsFailure();

  @override
  List<Object?> get props => [];
}
