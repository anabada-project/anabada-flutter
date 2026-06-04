import 'package:flutter/material.dart';

class ItemEmptyState extends StatelessWidget {
  const ItemEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '등록된 물건이 없습니다.',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9E9E9E),
        ),
      ),
    );
  }
}
