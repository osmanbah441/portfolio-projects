import 'package:app/api/api.dart';
import 'package:flutter/material.dart';

class CreateMenuItemScreen extends StatelessWidget {
  const CreateMenuItemScreen({
    super.key,
    required this.api,
    required this.onBackButtonTap,
    required this.onEditSuccess,
  });

  final Api api;
  final VoidCallback onBackButtonTap;
  final VoidCallback onEditSuccess;

  @override
  Widget build(BuildContext context) {
    return CreateMenuItemView(
      onBackButtonTap: onBackButtonTap,
      onEditSuccess: onEditSuccess,
    );
  }
}

@visibleForTesting
class CreateMenuItemView extends StatelessWidget {
  const CreateMenuItemView({
    super.key,
    required this.onBackButtonTap,
    required this.onEditSuccess,
  });

  final VoidCallback onBackButtonTap;
  final VoidCallback onEditSuccess;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: onBackButtonTap),
        centerTitle: true,
        title: const Text('create menu item'),
      ),
      body: const Center(
        child: Text('create menu item '),
      ),
    );
  }
}
