import 'package:flutter/material.dart';

import 'item_detail_category_chip.dart';

class ItemDetailInfoSection extends StatelessWidget {
  const ItemDetailInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '제목',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 14),
        ItemDetailCategoryChip(text: '카테고리'),
        SizedBox(height: 28),
        Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
        SizedBox(height: 26),
        Text(
          '물건 설명',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 14),
        Text(
          '설명',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF666666),
          ),
        ),
        SizedBox(height: 28),
        Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
      ],
    );
  }
}
