import 'package:flutter/material.dart';

import '../models/trade_item.dart';
import 'item_detail_category_chip.dart';

class ItemDetailInfoSection extends StatelessWidget {
  const ItemDetailInfoSection({super.key, required this.item});

  final TradeItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 14),
        ItemDetailCategoryChip(text: item.category.label),
        const SizedBox(height: 28),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
        const SizedBox(height: 26),
        const Text(
          '물건 설명',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          item.description,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 28),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
      ],
    );
  }
}
