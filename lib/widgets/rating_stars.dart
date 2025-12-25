import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;
  final Color backgroundColor;
  final bool allowHalfRating;

  RatingStars({
    required this.rating,
    this.size = 16,
    this.color = Colors.amber,
    this.backgroundColor = Colors.grey,
    this.allowHalfRating = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starRating = index + 1;
        
        if (rating >= starRating) {
          // Full star
          return Icon(
            Icons.star,
            size: size,
            color: color,
          );
        } else if (allowHalfRating && rating >= starRating - 0.5) {
          // Half star
          return Icon(
            Icons.star_half,
            size: size,
            color: color,
          );
        } else {
          // Empty star
          return Icon(
            Icons.star_border,
            size: size,
            color: backgroundColor,
          );
        }
      }),
    );
  }
}