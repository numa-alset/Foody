import 'package:flutter/material.dart';
import 'package:foody/core/models/review.dart';

class ReviewTile extends StatelessWidget {
  final Review review;

  const ReviewTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                size: 18,
                color: index < review.rating
                    ? Colors.orange
                    : Colors.grey.shade300,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(review.comment),
          const SizedBox(height: 4),
          Text(
            review.createdAt.toLocal().toString().substring(0, 16),
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
