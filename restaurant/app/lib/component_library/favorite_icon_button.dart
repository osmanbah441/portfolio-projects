import 'package:flutter/material.dart';

class FavoriteIconButton extends StatelessWidget {
  const FavoriteIconButton({
    required this.isFavorite,
    this.onTap,
    super.key,
  });

  final bool isFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      tooltip: isFavorite ? 'unfavorite' : 'favorite',
      color: Colors.red,
      iconSize: 32,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
      ),
    );
  }
}
