part of 'order_details_cubit.dart';

sealed class OrderDetailState {
  const OrderDetailState();
}

class OrderDetailsSuccess extends OrderDetailState {
  final Order order;
  final List<User> deliveryCrew;

  const OrderDetailsSuccess({
    required this.order,
    this.deliveryCrew = const [],
  });
}

class OrderDetailsInProgress extends OrderDetailState {
  const OrderDetailsInProgress();
}

class OrderDetailsFailure extends OrderDetailState {
  const OrderDetailsFailure();
}
