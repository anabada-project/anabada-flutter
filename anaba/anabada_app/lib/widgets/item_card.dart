import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ItemCard extends StatelessWidget {
  final String status;
  final bool isDone;
  final VoidCallback? onTap;

  const ItemCard({
    super.key,
    required this.status,
    required this.isDone,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 145,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Stack(
              children: [
                Container(
                  height: 150,

                  decoration: BoxDecoration(
                    color: AppColors.lightGray,

                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                Positioned(
                  top: 10,
                  left: 10,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: isDone ? Colors.white : const Color(0xFFFFF1B8),

                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: Text(
                      status,

                      style: TextStyle(
                        fontSize: 12,

                        color: isDone ? Colors.grey : AppColors.mainColor,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Text(
              '제목',

              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            const Text(
              '교환 물품:',

              style: TextStyle(color: AppColors.grayText, fontSize: 15),
            ),

            const SizedBox(height: 8),

            const Row(
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 18,
                  color: AppColors.grayText,
                ),

                SizedBox(width: 4),

                Text('78', style: TextStyle(color: AppColors.grayText)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
