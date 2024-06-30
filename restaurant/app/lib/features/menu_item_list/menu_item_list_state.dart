part of 'menu_item_list_bloc.dart';

final class MenuItemListState extends Equatable {
  const MenuItemListState({
    this.itemList,
    this.nextPage,
    this.filter,
    this.error,
    this.refreshError,
    this.favoriteToggleError,
  });

  final List<MenuItem>? itemList;
  final int? nextPage;
  final MenuItemListFilter? filter;
  final dynamic error;
  final dynamic refreshError;
  final dynamic favoriteToggleError;

  const MenuItemListState.noItemsFound(MenuItemListFilter? filter)
      : this(
          itemList: const [],
          nextPage: 1,
          filter: filter,
          error: null,
        );

  const MenuItemListState.success({
    required int? nextPage,
    required List<MenuItem> itemList,
    required MenuItemListFilter? filter,
    required bool isRefresh,
  }) : this(
          nextPage: nextPage,
          itemList: itemList,
          filter: filter,
        );

  MenuItemListState.loadingNewTag(MenuItemCategory? tag)
      : this(
          filter: tag != null ? MenuItemListFilterByTag(tag) : null,
        );

  MenuItemListState.loadingNewSearchTerm(String? searchTerm)
      : this(
          filter: searchTerm != null
              ? MenuItemListFilterBySearchTerm(searchTerm)
              : null,
        );

  MenuItemListState copyWithNewError(
    dynamic error,
  ) =>
      MenuItemListState(
        itemList: itemList,
        nextPage: nextPage,
        error: error,
        filter: filter,
        refreshError: null,
      );

  MenuItemListState copyWithNewRefreshError(
    dynamic refreshError,
  ) =>
      MenuItemListState(
        itemList: itemList,
        nextPage: nextPage,
        error: error,
        filter: filter,
        refreshError: refreshError,
        favoriteToggleError: null,
      );

  MenuItemListState copyWithUpdatedMenuItem(
    MenuItem updatedMenuItem,
  ) {
    return MenuItemListState(
      itemList: itemList?.map((product) {
        if (product.id == updatedMenuItem.id) {
          return updatedMenuItem;
        } else {
          return product;
        }
      }).toList(),
      nextPage: nextPage,
      error: error,
      filter: filter,
      refreshError: null,
      favoriteToggleError: null,
    );
  }

  @override
  List<Object?> get props => [
        itemList,
        nextPage,
        filter,
        error,
        refreshError,
        favoriteToggleError,
      ];
}

abstract base class MenuItemListFilter extends Equatable {
  const MenuItemListFilter();

  @override
  List<Object?> get props => [];
}

final class MenuItemListFilterBySearchTerm extends MenuItemListFilter {
  const MenuItemListFilterBySearchTerm(this.searchTerm);

  final String searchTerm;

  @override
  List<Object?> get props => [searchTerm];
}

final class MenuItemListFilterByTag extends MenuItemListFilter {
  const MenuItemListFilterByTag(this.tag);

  final MenuItemCategory tag;

  @override
  List<Object?> get props => [tag];
}
