import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AdminMainItemCard extends StatelessWidget {
  const AdminMainItemCard({
    super.key,
    required this.status,
    required this.isDone,
  });

  final String status;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 145,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.itemImageGray,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDone
                        ? AppColors.lightGray
                        : AppColors.yellowChipBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    status,
                    style: isDone
                        ? AppTextStyles.adminItemStatusDone
                        : AppTextStyles.adminItemStatusActive,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text('제목', style: AppTextStyles.adminItemTitle),

          const SizedBox(height: 8),

          const Text('교환 물건:', style: AppTextStyles.adminItemDescription),

          const SizedBox(height: 8),

          const Row(
            children: [
              Icon(Icons.favorite_border, size: 16, color: AppColors.grayText),

              SizedBox(width: 4),

              Text('78', style: AppTextStyles.adminItemLike),
            ],
          ),
        ],
      ),
    );
  }
}
