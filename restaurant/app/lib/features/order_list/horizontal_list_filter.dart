import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component_library/component_library.dart';
import '../../domain_models/domain_models.dart';
import 'order_list_bloc.dart';

class FilterHorizontalList extends StatelessWidget {
  const FilterHorizontalList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children:
            OrderStatus.values.map((tag) => _TagChip(status: tag)).toList(),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.status,
  });

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final isLastTag = OrderStatus.values.last == status;
    return Padding(
      padding: EdgeInsets.only(
        right: isLastTag ? 8 : 4,
        left: 4,
      ),
      child: BlocSelector<OrderListBloc, OrderListState, OrderStatus?>(
        selector: (state) {
          final filter = state.filter;
          final selectedTag =
              filter is OrderListFilterByStatus ? filter.status : null;
          return selectedTag;
        },
        builder: (context, selectedTag) {
          final isSelected = selectedTag == status;
          return RoundedChoiceChip(
            label: status.toLocalizedString(context),
            isSelected: isSelected,
            onSelected: (isSelected) {
              _releaseFocus(context);
              final bloc = context.read<OrderListBloc>();
              bloc.add(
                OrderListStatusChanged(isSelected ? status : null),
              );
            },
          );
        },
      ),
    );
  }
}

void _releaseFocus(BuildContext context) {
  FocusScope.of(context).unfocus();
}

extension on OrderStatus {
  String toLocalizedString(BuildContext context) => switch (this) {
        OrderStatus.pending => OrderStatus.pending.name,
        OrderStatus.ongoing => OrderStatus.ongoing.name,
        OrderStatus.completed => OrderStatus.completed.name,
      };
}
