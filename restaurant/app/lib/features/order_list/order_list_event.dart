part of 'order_list_bloc.dart';

sealed class OrderListEvent extends Equatable {
  const OrderListEvent();

  @override
  List<Object?> get props => [];
}

final class OrderListStatusChanged extends OrderListEvent {
  const OrderListStatusChanged(this.tag);

  final OrderStatus? tag;

  @override
  List<Object?> get props => [tag];
}

final class OrderListRefreshed extends OrderListEvent {
  const OrderListRefreshed();
}

final class OrderListNextPageRequested extends OrderListEvent {
  const OrderListNextPageRequested(this.pageNumber);

  final int pageNumber;

  @override
  List<Object?> get props => [pageNumber];
}

final class OrderListFailedFetchRetried extends OrderListEvent {
  const OrderListFailedFetchRetried();
}

final class OrderListFetchFirstPage extends OrderListEvent {
  const OrderListFetchFirstPage();
}
