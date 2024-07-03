import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/api.dart';
import '../../domain_models/domain_models.dart';

part 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailState> {
  OrderDetailsCubit({required this.orderId, required Api api})
      : _api = api,
        super(const OrderDetailsInProgress()) {
    if (_api.currentUser != null && api.currentUser!.isManager) {
      _fetchDeliveryUsersWithOrder();
    } else {
      _fetchOrder();
    }
  }

  final int orderId;
  final Api _api;

  void _fetchOrder() async {
    try {
      final order = await _api.getOrder(orderId);
      emit(OrderDetailsSuccess(order: order));
    } catch (e) {
      emit(const OrderDetailsFailure());
    }
  }

  void _fetchDeliveryUsersWithOrder() async {
    try {
      final order = await _api.getOrder(orderId);
      final users = await _api.getDeliveryCrewUser();

      emit(OrderDetailsSuccess(
        order: order,
        deliveryCrew: users,
      ));
    } catch (e) {
      emit(const OrderDetailsFailure());
    }
  }

  // update the status to 1 to complete the order
  void updateOrderStatusToCompleted() async {
    final isSucessState = state is OrderDetailsSuccess;
    if (isSucessState) {
      try {
        final previousState = state as OrderDetailsSuccess;
        final newOrder = await _api.updateOrderStatus(orderId, 1);
        emit(OrderDetailsSuccess(
          order: newOrder,
          deliveryCrew: previousState.deliveryCrew,
        ));
      } catch (e) {
        print(e);
        emit(const OrderDetailsFailure());
      }
    }
  }

  void assignDeliveryCrew(int userId) async {
    final isSucessState = state is OrderDetailsSuccess;
    if (isSucessState) {
      try {
        final previousState = state as OrderDetailsSuccess;
        final newOrder = await _api.assignDeliveryCrew(orderId, userId);
        emit(OrderDetailsSuccess(
          order: newOrder,
          deliveryCrew: previousState.deliveryCrew,
        ));
      } catch (e) {
        print(e);
        emit(const OrderDetailsFailure());
      }
    }
  }

  bool get isManager =>
      (_api.currentUser != null) ? _api.currentUser!.isManager : false;

  bool get canUpdate => (_api.currentUser != null)
      ? _api.currentUser!.isDeliveryCrew || isManager
      : false;
}
