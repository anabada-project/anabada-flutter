import 'package:flutter/material.dart';

class ItemListCountHeader extends StatelessWidget {
  final int totalCount;

  const ItemListCountHeader({super.key, required this.totalCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '전체 물건',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        Text(
          '총 $totalCount개',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9E9E9E),
          ),
        ),
      ],
    );
  }
}
