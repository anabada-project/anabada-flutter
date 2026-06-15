import 'package:flutter/material.dart';

import '../models/trade_item.dart';
import 'common/item_image.dart';
import 'item_status_chip.dart';

class ItemListCard extends StatelessWidget {
  final TradeItem item;
  final String time;
  final VoidCallback? onTap;

  const ItemListCard({
    super.key,
    required this.item,
    required this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 104,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemImage(
              imageBytes: item.imageBytes,
              imageUrl: item.imageUrl,
              width: 96,
              height: 96,
              borderRadius: 10,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 96,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ItemStatusChip(
                          status: item.statusLabel,
                          isActive: item.isActive,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.ownerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Container(
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F4F4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.category.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFBDBDBD),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFBDBDBD),
                          ),
                        ),
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
