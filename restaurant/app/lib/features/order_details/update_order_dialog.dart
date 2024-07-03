import 'package:flutter/material.dart';

import '../../domain_models/domain_models.dart';

class UpdateOrderToCompletedDialog extends StatelessWidget {
  const UpdateOrderToCompletedDialog({
    super.key,
    required this.onUpdate,
    required this.alreadyUpdated,
  });

  final VoidCallback? onUpdate;
  final bool alreadyUpdated;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(alreadyUpdated ? 'already completed' : 'Update order'),
      content: Text(
        alreadyUpdated
            ? 'updates are not possible for completed orders. If you need to make changes, please contact the manager'
            : "You're almost done! Updating your assigned order to complete the delivery.",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('cancel'),
        ),
        TextButton(
          onPressed: onUpdate != null
              ? () {
                  onUpdate!();
                  Navigator.pop(context);
                }
              : null,
          child: const Text('update'),
        ),
      ],
    );
  }
}

class AssignOrderToDeliveryCrewDialog extends StatefulWidget {
  const AssignOrderToDeliveryCrewDialog({
    super.key,
    required this.onAssigned,
    required this.deliveryUsers,
  });

  final Function(int) onAssigned;
  final List<User> deliveryUsers;

  @override
  State<AssignOrderToDeliveryCrewDialog> createState() =>
      _AssignOrderToDeliveryCrewDialogState();
}

class _AssignOrderToDeliveryCrewDialogState
    extends State<AssignOrderToDeliveryCrewDialog> {
  int? _selectedUserId;

  void _onUserSelected(User user) => setState(() {
        _selectedUserId = user.id;
      });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Assign Order to:'),
      content: Column(
        children: widget.deliveryUsers.map((user) {
          return ListTile(
            onTap: () => _onUserSelected(user),
            title: Text(user.username), // Assuming 'name' is a property of User
            trailing: _selectedUserId == user.id
                ? const Icon(
                    Icons.radio_button_checked) // Show selected indicator
                : null,
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('cancel'),
        ),
        TextButton(
          onPressed: (_selectedUserId != null)
              ? () {
                  widget.onAssigned(_selectedUserId!);
                  Navigator.pop(context);
                }
              : null,
          child: const Text('assign'),
        ),
      ],
    );
  }
}
