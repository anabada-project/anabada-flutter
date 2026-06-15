import 'package:flutter/material.dart';

import '../models/trade_item.dart';
import '../constants/app_colors.dart';
import 'common/item_image.dart';

class ItemCard extends StatelessWidget {
  final TradeItem item;
  final VoidCallback? onTap;

  const ItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
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
                  height: 150,
                  borderRadius: 16,
                ),

                Positioned(
                  top: 10,
                  left: 10,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: item.isActive
                          ? const Color(0xFFFFF1B8)
                          : Colors.white,

                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: Text(
                      item.statusLabel,

                      style: TextStyle(
                        fontSize: 12,

                        color: item.isActive
                            ? AppColors.mainColor
                            : Colors.grey,

                        fontWeight: FontWeight.bold,
                      ),
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
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              item.tradeMethod == TradeMethod.exchange
                  ? '교환 물품: ${item.wantedItem.isEmpty ? '협의' : item.wantedItem}'
                  : '무료 나눔',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.grayText, fontSize: 15),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(
                  Icons.favorite_border,
                  size: 18,
                  color: AppColors.grayText,
                ),

                const SizedBox(width: 4),

                Text(
                  '${item.likeCount}',
                  style: const TextStyle(color: AppColors.grayText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
