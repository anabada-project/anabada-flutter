import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/trade_item.dart';
import 'common/item_image.dart';

class AdminMainItemCard extends StatelessWidget {
  const AdminMainItemCard({super.key, required this.item});

  final TradeItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ItemImage(
                imageBytes: item.imageBytes,
                imageUrl: item.imageUrl,
                width: 145,
                height: 140,
                borderRadius: 14,
                backgroundColor: AppColors.itemImageGray,
              ),

              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: item.isActive
                        ? AppColors.yellowChipBackground
                        : AppColors.lightGray,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    item.statusLabel,
                    style: item.isActive
                        ? AppTextStyles.adminItemStatusActive
                        : AppTextStyles.adminItemStatusDone,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.adminItemTitle,
          ),

          const SizedBox(height: 8),

          Text(
            item.tradeMethod == TradeMethod.exchange
                ? '교환 물건: ${item.wantedItem}'
                : '무료 나눔',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.adminItemDescription,
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.favorite_border,
                size: 16,
                color: AppColors.grayText,
              ),

              const SizedBox(width: 4),

              Text('${item.likeCount}', style: AppTextStyles.adminItemLike),
            ],
          ),
        ],
      ),
    );
  }
}
