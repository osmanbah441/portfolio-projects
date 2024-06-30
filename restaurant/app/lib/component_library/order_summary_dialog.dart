import 'package:flutter/material.dart';

class OrderSummaryDialog extends StatelessWidget {
  const OrderSummaryDialog({
    super.key,
    required this.onOrderConfirmed,
    required this.totalQuantity,
    required this.totalPrice,
  });

  final VoidCallback onOrderConfirmed;
  final int totalQuantity;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmation Order'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Total Quantity: $totalQuantity'),
          const SizedBox(height: 8),
          Text('Total MenuItems Price: \$${totalPrice.toStringAsFixed(2)}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Close the dialog
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onOrderConfirmed,
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
