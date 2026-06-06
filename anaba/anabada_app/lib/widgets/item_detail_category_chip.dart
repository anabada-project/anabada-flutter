import 'package:flutter/material.dart';

class ItemDetailCategoryChip extends StatelessWidget {
  final String text;

  const ItemDetailCategoryChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFFBDBDBD),
        ),
      ),
    );
  }
}
