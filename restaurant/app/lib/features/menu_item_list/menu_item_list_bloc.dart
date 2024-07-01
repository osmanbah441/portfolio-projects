import 'dart:async';

import 'package:app/api/api.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain_models/domain_models.dart';

part 'menu_item_list_event.dart';
part 'menu_item_list_state.dart';

final class MenuItemListBloc
    extends Bloc<MenuItemListEvent, MenuItemListState> {
  MenuItemListBloc({required Api api})
      : _api = api,
        super(const MenuItemListState()) {
    _registerEventHandlers();

    add(const MenuItemListFirstPageRequested());
  }

  final Api _api;

  void _registerEventHandlers() => on<MenuItemListEvent>(
        (event, emitter) async => switch (event) {
          MenuItemListTagChanged() =>
            _handleMenuItemListTagChanged(emitter, event),
          MenuItemListSearchTermChanged() =>
            _handleMenuItemListSearchTermChanged(emitter, event),
          MenuItemListRefreshed() =>
            _handleMenuItemListRefreshed(emitter, event),
          MenuItemListNextPageRequested() =>
            _handleMenuItemListNextPageRequested(emitter, event),
          MenuItemListFailedFetchRetried() =>
            _handleMenuItemListFailedFetchRetried(emitter),
          MenuItemListFirstPageRequested() =>
            _handleMenuItemListUsernameObtained(emitter),
        },
        transformer: (eventStream, eventHandler) {
          final nonDebounceEventStream = eventStream.where(
            (event) => event is! MenuItemListSearchTermChanged,
          );

          final debounceEventStream = eventStream
              .whereType<MenuItemListSearchTermChanged>()
              .debounceTime(const Duration(seconds: 1))
              .where((event) {
            final previousFilter = state.filter;
            final previousSearchTerm =
                previousFilter is MenuItemListFilterBySearchTerm
                    ? previousFilter.searchTerm
                    : '';

            return event.searchTerm != previousSearchTerm;
          });

          final mergedEventStream = MergeStream([
            nonDebounceEventStream,
            debounceEventStream,
          ]);

          final restartableTransformer = restartable<MenuItemListEvent>();
          return restartableTransformer(mergedEventStream, eventHandler);
        },
      );

  Future<void> _handleMenuItemListFailedFetchRetried(Emitter emitter) {
    // Clears out the error and puts the loading indicator back on the screen.
    emitter(state.copyWithNewError(null));
    final firstPageFetchStream = _fetchMenuItemPage(1);

    return emitter.onEach<MenuItemListState>(
      firstPageFetchStream.asStream(),
      onData: emitter.call,
    );
  }

  Future<void> _handleMenuItemListUsernameObtained(Emitter emitter) {
    emitter(MenuItemListState(filter: state.filter));

    final firstPageFetchStream = _fetchMenuItemPage(1);

    return emitter.onEach<MenuItemListState>(
      firstPageFetchStream.asStream(),
      onData: emitter.call,
    );
  }

  Future<void> _handleMenuItemListTagChanged(
    Emitter emitter,
    MenuItemListTagChanged event,
  ) {
    emitter(
      MenuItemListState.loadingNewTag(event.tag),
    );

    final firstPageFetchStream = _fetchMenuItemPage(
      1,
      // If the user is *deselecting* a tag, the `cachePreferably` fetch policy
      // will return you the cached MenuItems. If the user is selecting a new tag
      // instead, the `cachePreferably` fetch policy won't find any cached
      // MenuItems and will instead use the network.
    );

    return emitter.onEach<MenuItemListState>(
      firstPageFetchStream.asStream(),
      onData: emitter.call,
    );
  }

  Future<void> _handleMenuItemListSearchTermChanged(
    Emitter emitter,
    MenuItemListSearchTermChanged event,
  ) {
    emitter(MenuItemListState.loadingNewSearchTerm(event.searchTerm));

    final firstPageFetchStream = _fetchMenuItemPage(
      1,
      // If the user is *clearing out* the search bar, the `cachePreferably`
      // fetch policy will return you the cached MenuItems. If the user is
      // entering a new search instead, the `cachePreferably` fetch policy
      // won't find any cached MenuItems and will instead use the network.
    );

    return emitter.onEach<MenuItemListState>(
      firstPageFetchStream.asStream(),
      onData: emitter.call,
    );
  }

  Future<void> _handleMenuItemListRefreshed(
    Emitter emitter,
    MenuItemListRefreshed event,
  ) {
    final firstPageFetchStream = _fetchMenuItemPage(
      1,
      // Since the user is asking for a refresh, you don't want to get cached
      // MenuItems, thus the `networkOnly` fetch policy makes the most sense.
      isRefresh: true,
    );

    return emitter.onEach<MenuItemListState>(
      firstPageFetchStream.asStream(),
      onData: emitter.call,
    );
  }

  Future<void> _handleMenuItemListNextPageRequested(
    Emitter emitter,
    MenuItemListNextPageRequested event,
  ) {
    emitter(
      state.copyWithNewError(null),
    );

    final nextPageFetchStream = _fetchMenuItemPage(
      event.pageNumber,
      // The `networkPreferably` fetch policy prioritizes fetching the new page
      // from the server, and, if it fails, try grabbing it from the cache.
    );

    return emitter.onEach<MenuItemListState>(
      nextPageFetchStream.asStream(),
      onData: emitter.call,
    );
  }

  Future<MenuItemListState> _fetchMenuItemPage(
    int page, {
    bool isRefresh = false,
  }) async {
    final currentlyAppliedFilter = state.filter;

    try {
      final newPage = await _api.getMenuItemListPage(
        page: page,
        category: currentlyAppliedFilter is MenuItemListFilterByTag
            ? currentlyAppliedFilter.tag
            : null,
        searchTerm: currentlyAppliedFilter is MenuItemListFilterBySearchTerm
            ? currentlyAppliedFilter.searchTerm
            : '',
      );

      final newItemList = newPage.productList;
      final oldItemList = state.itemList ?? [];
      final completeItemList =
          isRefresh || page == 1 ? newItemList : (oldItemList + newItemList);

      final nextPage = newPage.isLastPage ? null : page + 1;

      return MenuItemListState.success(
        nextPage: nextPage,
        itemList: completeItemList,
        filter: currentlyAppliedFilter,
        isRefresh: isRefresh,
      );
    } catch (error) {
      if (error is EmptySearchResultException) {
        return MenuItemListState.noItemsFound(
          currentlyAppliedFilter,
        );
      }

      if (isRefresh) {
        return state.copyWithNewRefreshError(
          error,
        );
      } else {
        return state.copyWithNewError(
          error,
        );
      }
    }
  }
}
