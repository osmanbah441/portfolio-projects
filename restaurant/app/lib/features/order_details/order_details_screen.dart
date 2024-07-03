import 'package:app/features/order_details/update_order_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/api.dart';
import '../../domain_models/domain_models.dart';
import '../../component_library/component_library.dart';
import 'order_details_cubit.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({
    super.key,
    required this.onBackButtonTap,
    required this.orderId,
    required this.api,
  });

  final int orderId;
  final Api api;
  final VoidCallback onBackButtonTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderDetailsCubit>(
      create: (context) => OrderDetailsCubit(
        orderId: orderId,
        api: api,
      ),
      child: OrderDetailsView(
        onBackButtonTap: onBackButtonTap,
      ),
    );
  }
}

@visibleForTesting
class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({
    super.key,
    required this.onBackButtonTap,
  });

  final VoidCallback onBackButtonTap;

  void _showUpdateOrderToCompletedDialog(
    BuildContext context, {
    required VoidCallback? onUpdateStatusTapped,
    required bool alreadyUpdated,
  }) async =>
      showDialog(
        context: context,
        builder: (context) => UpdateOrderToCompletedDialog(
          onUpdate: onUpdateStatusTapped,
          alreadyUpdated: alreadyUpdated,
        ),
      );

  void _showAssignOrderToDeliveryCrewDialog(
    BuildContext context,
    Function(int) onAssignedDeliveryTapped,
    List<User> deliveryCrews,
  ) async =>
      showDialog(
          context: context,
          builder: (context) => AssignOrderToDeliveryCrewDialog(
                onAssigned: onAssignedDeliveryTapped,
                deliveryUsers: deliveryCrews,
              ));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsCubit, OrderDetailState>(
      builder: (context, state) {
        final cubit = context.read<OrderDetailsCubit>();

        return Scaffold(
          appBar: state is OrderDetailsSuccess
              ? AppBar(
                  centerTitle: true,
                  title: Text('order ${state.order.status.name}'),
                  leading: BackButton(onPressed: onBackButtonTap),
                  actions: [
                      if (cubit.canUpdate)
                        IconButton(
                          onPressed: () {
                            cubit.isManager
                                ? _showAssignOrderToDeliveryCrewDialog(
                                    context,
                                    cubit.assignDeliveryCrew,
                                    state.deliveryCrew)
                                : _showUpdateOrderToCompletedDialog(
                                    context,
                                    alreadyUpdated: state.order.status ==
                                        OrderStatus.completed,
                                    onUpdateStatusTapped: state.order.status ==
                                            OrderStatus.ongoing
                                        ? cubit.updateOrderStatusToCompleted
                                        : null,
                                  );
                          },
                          icon: const Icon(Icons.edit),
                        )
                    ])
              : null,
          body: SafeArea(
            child: switch (state) {
              OrderDetailsInProgress() =>
                const CenteredCircularProgressIndicator(),
              OrderDetailsSuccess() => _OrderDetails(order: state.order),
              OrderDetailsFailure() => const ExceptionIndicator()
            },
          ),
        );
      },
    );
  }
}

class _OrderDetails extends StatelessWidget {
  const _OrderDetails({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: order.orderItems.length,
      itemBuilder: (BuildContext context, int index) {
        final orderItem = order.orderItems[index];
        final menuItem = orderItem.menuItem;

        final textStyle = TextStyle(
          color: Colors.white,
          fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
        );

        return Stack(
          children: [
            Image.asset(
              menuItem.imageUrl,
              color: Colors.black.withOpacity(0.4),
              width: double.infinity,
              colorBlendMode: BlendMode.darken,
              height: 300,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Text(menuItem.title, style: textStyle),
            ),
            Positioned(
              bottom: 64,
              left: 16,
              child: Text('unit price', style: textStyle),
            ),
            Positioned(
              bottom: 64,
              right: 16,
              child: Text(orderItem.unitPrice.toString(), style: textStyle),
            ),
            Positioned(
              bottom: 32,
              left: 16,
              child: Text('quantity', style: textStyle),
            ),
            Positioned(
              bottom: 32,
              right: 16,
              child: Text(orderItem.quantity.toString(), style: textStyle),
            ),
            Positioned(
              bottom: 8,
              left: 16,
              child: Text('price', style: textStyle),
            ),
            Positioned(
              bottom: 8,
              right: 16,
              child: Text(orderItem.price.toString(), style: textStyle),
            ),
          ],
        );
      },
    );
  }
}
