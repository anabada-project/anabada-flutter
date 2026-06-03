import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'favorite_status_chip.dart';

class FavoriteItemCard extends StatelessWidget {
  final String title;
  final String writer;
  final String category;
  final String status;
  final String time;
  final bool isActive;

  const FavoriteItemCard({
    super.key,
    required this.title,
    required this.writer,
    required this.category,
    required this.status,
    required this.time,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.itemImageGray,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 96,
              child: Stack(
                children: [
                  Positioned(
                    top: 4,
                    left: 0,
                    child: Text(title, style: AppTextStyles.favoriteItemTitle),
                  ),
                  Positioned(
                    top: 30,
                    left: 0,
                    child: Text(
                      writer,
                      style: AppTextStyles.favoriteItemWriter,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.disabledButton,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        category,
                        style: AppTextStyles.favoriteItemCategory,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 0,
                    child: FavoriteStatusChip(
                      status: status,
                      isActive: isActive,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 4,
                    child: Text(time, style: AppTextStyles.favoriteItemTime),
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
