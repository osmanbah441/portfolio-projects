import 'package:app/component_library/exception_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../domain_models/domain_models.dart';
import 'order_list_bloc.dart';

class OrderPageListView extends StatelessWidget {
  const OrderPageListView({
    super.key,
    required this.pagingController,
    required this.onOrderSelected,
  });

  final PagingController<int, Order> pagingController;
  final void Function(int) onOrderSelected;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<OrderListBloc, OrderListState>(
        builder: (context, state) {
          return PagedListView(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<Order>(
                firstPageErrorIndicatorBuilder: (context) {
              final bloc = context.read<OrderListBloc>();
              return state.error is TemporalServerDownException
                  ? ExceptionIndicator.serverDown(
                      onTryAgain: () =>
                          bloc.add(const OrderListFailedFetchRetried()),
                    )
                  : ExceptionIndicator(
                      onTryAgain: () =>
                          bloc.add(const OrderListFailedFetchRetried()),
                    );
            }, itemBuilder: (context, order, index) {
              return Card(
                child: ListTile(
                  titleTextStyle: Theme.of(context).textTheme.labelLarge,
                  subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
                  leading: order.status._icon,
                  onTap: () => onOrderSelected(order.id),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Row(label: 'ID', value: order.id.toString()),
                      _Row(
                        label: 'Total cost',
                        value: 'SLL ${order.total.toStringAsFixed(2)}',
                      )
                    ],
                  ),
                  subtitle: _Row(
                    label: 'Date',
                    value: order.getFormattedDate,
                  ),
                ),
              );
            }),
          );
        },
      );
}

extension on OrderStatus {
  Icon get _icon => switch (this) {
        OrderStatus.pending => const Icon(Icons.hourglass_empty_outlined),
        OrderStatus.completed => const Icon(Icons.done_outline),
        OrderStatus.ongoing => const Icon(Icons.gps_fixed_outlined),
      };
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label, value;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      );
}
