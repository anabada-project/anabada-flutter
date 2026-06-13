import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class FavoriteItemCard extends StatelessWidget {
  const FavoriteItemCard({
    super.key,
    required this.title,
    required this.author,
    required this.category,
    required this.status,
    required this.time,
    required this.isActive,
  });

  final String title;
  final String author;
  final String category;
  final String status;
  final String time;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 124,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              color: AppColors.itemImageGray,
              borderRadius: BorderRadius.circular(14),
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.favoriteItemTitle,
                        ),
                      ),

                      const SizedBox(width: 8),

                      _StatusChip(text: status, isActive: isActive),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(author, style: AppTextStyles.favoriteItemAuthor),

                  const Spacer(),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          category,
                          style: AppTextStyles.favoriteCategory,
                        ),
                      ),

                      const Spacer(),

                      Text(time, style: AppTextStyles.favoriteTime),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.text, required this.isActive});

  final String text;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isActive ? AppColors.yellowChipBackground : AppColors.lightGray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: isActive
            ? AppTextStyles.favoriteStatusActive
            : AppTextStyles.favoriteStatusDone,
      ),
    );
  }
}
