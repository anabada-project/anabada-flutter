import 'package:flutter/material.dart';

import '../models/trade_item.dart';

class ItemDetailWantedSection extends StatelessWidget {
  const ItemDetailWantedSection({super.key, required this.item});

  final TradeItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        Text(
          item.tradeMethod == TradeMethod.exchange ? '희망 교환 물품' : '거래 방식',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          item.tradeMethod == TradeMethod.exchange
              ? (item.wantedItem.isEmpty ? '협의 가능' : item.wantedItem)
              : '무료 나눔',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}
