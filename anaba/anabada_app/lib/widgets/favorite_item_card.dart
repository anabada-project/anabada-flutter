import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/trade_item.dart';
import 'common/item_image.dart';

class FavoriteItemCard extends StatelessWidget {
  const FavoriteItemCard({
    super.key,
    required this.item,
    required this.time,
    this.onTap,
  });

  final TradeItem item;
  final String time;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 124,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemImage(
              imageBytes: item.imageBytes,
              imageUrl: item.imageUrl,
              width: 124,
              height: 124,
              borderRadius: 14,
              backgroundColor: AppColors.itemImageGray,
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
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.favoriteItemTitle,
                          ),
                        ),

                        const SizedBox(width: 8),

                        _StatusChip(
                          text: item.statusLabel,
                          isActive: item.isActive,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      item.ownerName,
                      style: AppTextStyles.favoriteItemAuthor,
                    ),

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
                            item.category.label,
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
