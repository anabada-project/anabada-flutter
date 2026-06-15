import 'package:flutter/material.dart';

import '../models/trade_item.dart';
import 'common/item_image.dart';

class ItemDetailCommentTargetCard extends StatelessWidget {
  const ItemDetailCommentTargetCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final TradeItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 78,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFEDEDED)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
          ItemImage(
            imageBytes: item.imageBytes,
            imageUrl: item.imageUrl,
            width: 52,
            height: 52,
            borderRadius: 8,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8E8E8E),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 22, color: Color(0xFF9E9E9E)),
          ],
        ),
      ),
    );
  }
}
