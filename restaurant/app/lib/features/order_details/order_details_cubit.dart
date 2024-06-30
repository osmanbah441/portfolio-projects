import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/api.dart';
import '../../domain_models/domain_models.dart';

part 'order_details_state.dart';

// Cubit to manage order details state
class OrderDetailsCubit extends Cubit<OrderDetailState> {
  OrderDetailsCubit({required this.orderId, required Api api})
      : _api = api,
        super(OrderDetailsInProgress()) {
    _fetchOrder();
  }

  final int orderId;
  final Api _api;

  void _fetchOrder() async {
    try {
      final order = await _api.getOrder(orderId);
      emit(OrderDetailsSuccess(order: order));
    } catch (e) {
      emit(OrderDetailsFailure());
    }
  }
}
