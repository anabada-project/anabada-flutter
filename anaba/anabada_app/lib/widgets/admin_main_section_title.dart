import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AdminMainSectionTitle extends StatelessWidget {
  const AdminMainSectionTitle({
    super.key,
    required this.title,
    this.showAddButton = false,
  });

  final String title;
  final bool showAddButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppTextStyles.adminSectionTitle),

        if (showAddButton) ...[
          const SizedBox(width: 8),

          GestureDetector(
            onTap: () {},
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

        const Text('더보기', style: AppTextStyles.adminMoreText),

        const SizedBox(width: 4),

        const Icon(Icons.chevron_right, color: AppColors.grayText, size: 22),
      ],
    );
  }
}
