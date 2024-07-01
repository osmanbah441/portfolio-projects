import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../domain_models/domain_models.dart';
import '../../component_library/component_library.dart';
import 'menu_item_list_bloc.dart';

class MenuItemPagedGridView extends StatelessWidget {
  const MenuItemPagedGridView({
    super.key,
    required this.pagingController,
    required this.onMenuItemSelected,
  });

  final PagingController<int, MenuItem> pagingController;
  final MenuItemSelected onMenuItemSelected;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final bloc = context.read<MenuItemListBloc>();

          int gridColumnCount = constraints.maxWidth ~/ 160;
          gridColumnCount = max(1, min(gridColumnCount, 2));

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            // For a deep dive on how the pagination works, refer to: https://www.raywenderlich.com/14214369-infinite-scrolling-pagination-in-flutter
            child: PagedMasonryGridView.count(
                pagingController: pagingController,
                builderDelegate: PagedChildBuilderDelegate<MenuItem>(
                  itemBuilder: (context, product, index) {
                    return MenuItemCartCard(
                      item: product,
                      onTap: () => onMenuItemSelected(product.id),
                    );
                  },
                  firstPageErrorIndicatorBuilder: (context) {
                    return BlocBuilder<MenuItemListBloc, MenuItemListState>(
                      builder: (context, state) {
                        return state.error is TemporalServerDownException
                            ? ExceptionIndicator.serverDown(
                                onTryAgain: () => bloc.add(
                                    const MenuItemListFailedFetchRetried()),
                              )
                            : ExceptionIndicator(
                                onTryAgain: () => bloc.add(
                                    const MenuItemListFailedFetchRetried()),
                              );
                      },
                    );
                  },
                ),
                crossAxisCount: gridColumnCount,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4),
          );
        },
      );
}
