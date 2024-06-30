import 'package:equatable/equatable.dart';
import 'user.dart';
import 'menu_items.dart';

/// represents a user's written review for a specific product.
class Review extends Equatable {
  final String id;
  final User user;
  final MenuItem product;
  final int rating;
  final String reviewText;

  const Review({
    required this.id,
    required this.user,
    required this.product,
    required this.rating,
    required this.reviewText,
  });

  @override
  List<Object?> get props => [id, user, product, rating];
}
