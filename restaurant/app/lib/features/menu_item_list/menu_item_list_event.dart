part of 'menu_item_list_bloc.dart';

sealed class MenuItemListEvent extends Equatable {
  const MenuItemListEvent();

  @override
  List<Object?> get props => [];
}

final class MenuItemListTagChanged extends MenuItemListEvent {
  const MenuItemListTagChanged(this.tag);

  final MenuItemCategory? tag;

  @override
  List<Object?> get props => [tag];
}

final class MenuItemListSearchTermChanged extends MenuItemListEvent {
  const MenuItemListSearchTermChanged(this.searchTerm);

  final String searchTerm;

  @override
  List<Object?> get props => [searchTerm];
}

final class MenuItemListRefreshed extends MenuItemListEvent {
  const MenuItemListRefreshed();
}

final class MenuItemListNextPageRequested extends MenuItemListEvent {
  const MenuItemListNextPageRequested(this.pageNumber);

  final int pageNumber;

  @override
  List<Object?> get props => [pageNumber];
}

final class MenuItemListFailedFetchRetried extends MenuItemListEvent {
  const MenuItemListFailedFetchRetried();
}

final class MenuItemListFirstPageRequested extends MenuItemListEvent {
  const MenuItemListFirstPageRequested();
}
