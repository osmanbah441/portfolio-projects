import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component_library/component_library.dart';
import '../../domain_models/domain_models.dart';
import 'menu_item_list_bloc.dart';

class FilterHorizontalList extends StatelessWidget {
  const FilterHorizontalList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        ...MenuItemCategory.values.map((tag) => _TagChip(tag: tag)),
      ]),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.tag,
  });

  final MenuItemCategory tag;

  @override
  Widget build(BuildContext context) {
    final isLastTag = MenuItemCategory.values.last == tag;
    return Padding(
      padding: EdgeInsets.only(
        right: isLastTag ? 8 : 4,
        left: 4,
      ),
      child:
          BlocSelector<MenuItemListBloc, MenuItemListState, MenuItemCategory?>(
        selector: (state) {
          final filter = state.filter;
          final selectedTag =
              filter is MenuItemListFilterByTag ? filter.tag : null;
          return selectedTag;
        },
        builder: (context, selectedTag) {
          final isSelected = selectedTag == tag;
          return RoundedChoiceChip(
            label: tag.name,
            isSelected: isSelected,
            onSelected: (isSelected) {
              _releaseFocus(context);
              final bloc = context.read<MenuItemListBloc>();
              bloc.add(
                MenuItemListTagChanged(isSelected ? tag : null),
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
