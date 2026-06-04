import 'package:flutter/material.dart';

import 'item_status_chip.dart';

class ItemListCard extends StatelessWidget {
  final String title;
  final String writer;
  final String category;
  final String status;
  final String time;
  final bool isActive;

  const ItemListCard({
    super.key,
    required this.title,
    required this.writer,
    required this.category,
    required this.status,
    required this.time,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F1F3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 96,
              child: Stack(
                children: [
                  Positioned(
                    top: 2,
                    left: 0,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 27,
                    left: 0,
                    child: Text(
                      writer,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFBDBDBD),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 0,
                    child: ItemStatusChip(status: status, isActive: isActive),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 5,
                    child: Text(
                      time,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFBDBDBD),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
