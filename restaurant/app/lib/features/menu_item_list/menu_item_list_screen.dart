import 'package:app/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../domain_models/domain_models.dart';
import '../../component_library/component_library.dart';
import 'filter_horizontal_list.dart';
import 'menu_item_list_bloc.dart';
import 'menu_item_page_grid_view.dart';

class MenuItemListScreen extends StatelessWidget {
  const MenuItemListScreen({
    super.key,
    required this.api,
    required this.onMenuItemSelected,
    this.onProfileAvaterTap,
  });

  final MenuItemSelected onMenuItemSelected;
  final VoidCallback? onProfileAvaterTap;
  final Api api;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MenuItemListBloc>(
      create: (_) => MenuItemListBloc(api: api),
      child: MenuItemListView(
        onMenuItemSelected: onMenuItemSelected,
      ),
    );
  }
}

@visibleForTesting
class MenuItemListView extends StatefulWidget {
  const MenuItemListView({
    super.key,
    required this.onMenuItemSelected,
    this.onProfileAvaterTap,
  });

  final MenuItemSelected onMenuItemSelected;
  final VoidCallback? onProfileAvaterTap;

  @override
  State<MenuItemListView> createState() => _MenuItemListViewState();
}

class _MenuItemListViewState extends State<MenuItemListView> {
  final _pagingController = PagingController<int, MenuItem>(
    firstPageKey: 1,
  );

  final TextEditingController _searchBarController = TextEditingController();

  MenuItemListBloc get _bloc => context.read<MenuItemListBloc>();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageNumber) {
      if (pageNumber > 1) _bloc.add(MenuItemListNextPageRequested(pageNumber));
    });

    _searchBarController.addListener(() {
      _bloc.add(MenuItemListSearchTermChanged(_searchBarController.text));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuItemListBloc, MenuItemListState>(
      listener: (context, state) {
        final searchBarText = _searchBarController.text;
        final isSearching = state.filter != null &&
            state.filter is MenuItemListFilterBySearchTerm;
        if (searchBarText.isNotEmpty && !isSearching) {
          _searchBarController.text = '';
        }

        if (state.refreshError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('refresh errror text message')),
          );
        } else if (state.favoriteToggleError != null) {
          final snackBar =
              state.favoriteToggleError is UserAuthenticationRequiredException
                  ? const AuthenticationRequiredErrorSnackBar()
                  : const GenericErrorSnackBar();

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }

        _pagingController.value = state.toPagingState();
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SearchBar(
                  controller: _searchBarController,
                  elevation: WidgetStateProperty.all(1.0),
                  hintText: 'search',
                  leading: IconButton(
                    onPressed: widget.onProfileAvaterTap,
                    icon: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      foregroundImage:
                          AssetImage('assets/images/profile_1.jpg'),
                    ),
                  ),
                ),
              ),
              const FilterHorizontalList(),
              Expanded(
                child: RefreshIndicator(
                    onRefresh: () {
                      _bloc.add(const MenuItemListRefreshed());

                      final stateChangeFuture = _bloc.stream.first;
                      return stateChangeFuture;
                    },
                    child: MenuItemPagedGridView(
                      pagingController: _pagingController,
                      onMenuItemSelected: widget.onMenuItemSelected,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchBarController.dispose();
    super.dispose();
  }
}

extension on MenuItemListState {
  PagingState<int, MenuItem> toPagingState() {
    return PagingState(
      itemList: itemList,
      nextPageKey: nextPage,
      error: error,
    );
  }
}
