import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AdminMainSectionTitle extends StatelessWidget {
  const AdminMainSectionTitle({
    super.key,
    required this.title,
    required this.onMoreTap,
    this.showAddButton = false,
    this.onAddTap,
  });

  final String title;
  final VoidCallback onMoreTap;
  final bool showAddButton;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppTextStyles.adminSectionTitle),

        if (showAddButton) ...[
          const SizedBox(width: 8),

          GestureDetector(
            onTap: onAddTap,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.mainColor, width: 1.5),
              ),
              child: const Icon(
                Icons.add,
                size: 20,
                color: AppColors.mainColor,
              ),
            ),
          ),
        ],

        const Spacer(),

        InkWell(
          onTap: onMoreTap,
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Text('더보기', style: AppTextStyles.adminMoreText),
                SizedBox(width: 4),
                Icon(Icons.chevron_right, color: AppColors.grayText, size: 22),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
