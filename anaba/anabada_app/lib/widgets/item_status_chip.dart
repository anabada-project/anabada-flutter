import 'package:flutter/material.dart';

class ItemStatusChip extends StatelessWidget {
  final String status;
  final bool isActive;

  const ItemStatusChip({
    super.key,
    required this.status,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFFF4C2) : const Color(0xFFF0F1F3),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isActive ? const Color(0xFFFFB800) : const Color(0xFFBDBDBD),
        ),
      ),
    );
  }
}
