import 'package:app/api/api.dart';
import 'package:flutter/material.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({
    super.key,
    required this.api,
  });

  final Api api;

  @override
  Widget build(BuildContext context) {
    return const UserListScreenView();
  }
}

@visibleForTesting
class UserListScreenView extends StatelessWidget {
  const UserListScreenView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('users list screen '),
      ),
    );
  }
}
