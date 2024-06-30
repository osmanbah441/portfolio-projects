import 'package:flutter/material.dart';

class MenuItemQtyTile extends StatelessWidget {
  const MenuItemQtyTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.quantity,
    required this.price,
    this.onItemTap,
  });

  final String imageUrl, title;
  final int quantity;
  final double price;
  final VoidCallback? onItemTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: onItemTap,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                imageUrl,
                width: 100.0,
                height: 80.0,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleSmall,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Qty: $quantity',
                            style: textTheme.labelLarge,
                          ),
                          Text(
                            'SLL ${price.toStringAsFixed(2)}',
                            style: textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
