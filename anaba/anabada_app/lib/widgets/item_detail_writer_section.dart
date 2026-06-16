import 'package:flutter/material.dart';

import '../models/trade_item.dart';

class ItemDetailWriterSection extends StatelessWidget {
  const ItemDetailWriterSection({super.key, required this.item});

  final TradeItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 22),
        Row(
          children: [
            const _ProfileIcon(size: 48),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.ownerName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.ownerGeneration,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 22),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
      ],
    );
  }
}

class _ProfileIcon extends StatelessWidget {
  final double size;

  const _ProfileIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFE0E0E0),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, size: size * 0.65, color: Colors.white),
    );
  }
}
