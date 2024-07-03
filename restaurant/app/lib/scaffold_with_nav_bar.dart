part of 'routes.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    super.key,
    required this.child,
    required this.state,
    required this.user,
  });

  final Widget child;
  final GoRouterState state;
  final User user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: user.isDeliveryCrew
            ? null
            : user.isManager
                ? _BottomNavigationBarForManager(state: state)
                : _BottomNavigationBarForCustomer(state: state),
        body: child,
      ),
    );
  }
}

class _BottomNavigationBarForCustomer extends StatelessWidget {
  const _BottomNavigationBarForCustomer({
    required this.state,
  });

  final GoRouterState state;

  static const _customerNavigationDestination = [
    NavigationDestination(icon: Icon(Icons.travel_explore), label: 'explore'),
    NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'cart'),
    NavigationDestination(
        icon: Icon(Icons.manage_history_outlined), label: 'history'),
  ];

  int _selectedIndex() {
    return (state.fullPath == _PathConstants.shoppingCartPath)
        ? 1
        : (state.fullPath == _PathConstants.ordersListPath)
            ? 2
            : 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    (index == 1)
        ? context.go(_PathConstants.shoppingCartPath)
        : (index == 2)
            ? context.go(_PathConstants.ordersListPath)
            : context.go(_PathConstants.menuItemListPath);
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      selectedIndex: _selectedIndex(),
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      destinations: _customerNavigationDestination,
    );
  }
}

class _BottomNavigationBarForManager extends StatelessWidget {
  const _BottomNavigationBarForManager({
    required this.state,
  });

  final GoRouterState state;

  static const _customerNavigationDestination = [
    NavigationDestination(icon: Icon(Icons.travel_explore), label: 'explore'),
    NavigationDestination(icon: Icon(Icons.people), label: 'users'),
    NavigationDestination(
        icon: Icon(Icons.manage_history_outlined), label: 'history'),
  ];

  int _selectedIndex() {
    return (state.fullPath == _PathConstants.userListPath)
        ? 1
        : (state.fullPath == _PathConstants.ordersListPath)
            ? 2
            : 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    (index == 1)
        ? context.go(_PathConstants.userListPath)
        : (index == 2)
            ? context.go(_PathConstants.ordersListPath)
            : context.go(_PathConstants.menuItemListPath);
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      selectedIndex: _selectedIndex(),
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      destinations: _customerNavigationDestination,
    );
  }
}
