import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../api/api.dart';
import '../../domain_models/domain_models.dart';

part 'order_list_event.dart';
part 'order_list_state.dart';

final class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  OrderListBloc({required Api api})
      : _api = api,
        super(const OrderListState()) {
    _registerEventHandlers();

    add(const OrderListFetchFirstPage());
  }

  final Api _api;

  void _registerEventHandlers() => on<OrderListEvent>(
        (event, emitter) async => switch (event) {
          OrderListStatusChanged() =>
            _handleOrderListTagChanged(emitter, event),
          OrderListRefreshed() => _handleOrderListRefreshed(emitter, event),
          OrderListNextPageRequested() =>
            _handleOrderListNextPageRequested(emitter, event),
          OrderListFailedFetchRetried() =>
            _handleOrderListFailedFetchRetried(emitter),
          OrderListFetchFirstPage() =>
            _handleOrderListUsernameObtained(emitter),
        },
      );

  Future<void> _handleOrderListFailedFetchRetried(Emitter emitter) {
    // Clears out the error and puts the loading indicator back on the screen.
    emitter(state.copyWithNewError(null));

    final firstPageFetchStream = _fetchOrderPage(
      1,
    );

    return emitter.onEach<OrderListState>(
      firstPageFetchStream.asStream(),
      onData: emitter,
    );
  }

  Future<void> _handleOrderListUsernameObtained(Emitter emitter) {
    emitter(
      OrderListState(
        filter: state.filter,
      ),
    );

    final firstPageFetchStream = _fetchOrderPage(
      1,
    );

    return emitter.onEach<OrderListState>(
      firstPageFetchStream.asStream(),
      onData: emitter,
    );
  }

  Future<void> _handleOrderListTagChanged(
    Emitter emitter,
    OrderListStatusChanged event,
  ) {
    emitter(
      OrderListState.loadingNewTag(event.tag),
    );

    final firstPageFetchStream = _fetchOrderPage(
      1,
      // If the user is *deselecting* a tag, the `cachePreferably` fetch policy
      // will return you the cached Orders. If the user is selecting a new tag
      // instead, the `cachePreferably` fetch policy won't find any cached
      // Orders and will instead use the network.
    );

    return emitter.onEach<OrderListState>(
      firstPageFetchStream.asStream(),
      onData: emitter,
    );
  }

  Future<void> _handleOrderListRefreshed(
    Emitter emitter,
    OrderListRefreshed event,
  ) {
    final firstPageFetchStream = _fetchOrderPage(
      1,
      // Since the user is asking for a refresh, you don't want to get cached
      // Orders, thus the `networkOnly` fetch policy makes the most sense.
      isRefresh: true,
    );

    return emitter.onEach<OrderListState>(
      firstPageFetchStream.asStream(),
      onData: emitter,
    );
  }

  Future<void> _handleOrderListNextPageRequested(
    Emitter emitter,
    OrderListNextPageRequested event,
  ) {
    emitter(
      state.copyWithNewError(null),
    );

    final nextPageFetchStream = _fetchOrderPage(
      event.pageNumber,
      // The `networkPreferably` fetch policy prioritizes fetching the new page
      // from the server, and, if it fails, try grabbing it from the cache.
    );

    return emitter.onEach<OrderListState>(
      nextPageFetchStream.asStream(),
      onData: emitter,
    );
  }

  Future<OrderListState> _fetchOrderPage(
    int page, {
    bool isRefresh = false,
  }) async {
    final currentlyAppliedFilter = state.filter;

    try {
      final newPage = await _api.getOrderListPageByUser(
        status: currentlyAppliedFilter is OrderListFilterByStatus
            ? currentlyAppliedFilter.status.name
            : '',
      );

      final newItemList = newPage.orderList;
      final oldItemList = state.itemList ?? [];
      final completeItemList =
          isRefresh || page == 1 ? newItemList : (oldItemList + newItemList);

      final nextPage = newPage.isLastPage ? null : page + 1;

      return OrderListState.success(
        user: _api.currentUser!,
        nextPage: nextPage,
        itemList: completeItemList,
        filter: currentlyAppliedFilter,
        isRefresh: isRefresh,
      );
    } catch (error) {
      if (error is EmptySearchResultException) {
        return OrderListState.noItemsFound(
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
