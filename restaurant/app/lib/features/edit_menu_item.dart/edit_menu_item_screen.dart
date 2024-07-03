import 'package:app/api/api.dart';
import 'package:flutter/material.dart';

class EditMenuItemScreen extends StatelessWidget {
  const EditMenuItemScreen({
    super.key,
    required this.menuItemId,
    required this.api,
    required this.onBackButtonTap,
    required this.onEditSuccess,
  });

  final int menuItemId;
  final Api api;
  final VoidCallback onBackButtonTap;
  final VoidCallback onEditSuccess;

  @override
  Widget build(BuildContext context) {
    return EditMenuItemView(
      onBackButtonTap: onBackButtonTap,
      onEditSuccess: onEditSuccess,
    );
  }
}

@visibleForTesting
class EditMenuItemView extends StatelessWidget {
  const EditMenuItemView({
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
        title: const Text('Edit menu item'),
      ),
      body: const Center(
        child: Text('edit menu item '),
      ),
    );
  }
}
