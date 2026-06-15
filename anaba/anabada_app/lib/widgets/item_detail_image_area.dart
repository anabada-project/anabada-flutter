import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/trade_item.dart';
import 'common/item_image.dart';

class ItemDetailImageArea extends StatelessWidget {
  const ItemDetailImageArea({super.key, required this.item});

  final TradeItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemImage(
          imageBytes: item.imageBytes,
          imageUrl: item.imageUrl,
          width: double.infinity,
          height: 200,
        ),
        const SizedBox(height: 10),
        const _ImageIndicator(count: 1),
      ],
    );
  }
}

class _ImageIndicator extends StatelessWidget {
  const _ImageIndicator({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final bool isSelected = index == 0;

        return Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? AppColors.mainColor : const Color(0xFFE5E5E5),
          ),
        );
      }),
    );
  }
}
