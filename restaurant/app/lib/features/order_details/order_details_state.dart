part of 'order_details_cubit.dart';

sealed class OrderDetailState {}

class OrderDetailsSuccess extends OrderDetailState {
  final Order order;

  OrderDetailsSuccess({required this.order});
}

class OrderDetailsInProgress extends OrderDetailState {}

class OrderDetailsFailure extends OrderDetailState {}
