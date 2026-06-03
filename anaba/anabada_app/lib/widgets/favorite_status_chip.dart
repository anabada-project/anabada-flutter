import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class FavoriteStatusChip extends StatelessWidget {
  final String status;
  final bool isActive;

  const FavoriteStatusChip({
    super.key,
    required this.status,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.yellowChipBackground
            : AppColors.disabledButton,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: AppTextStyles.favoriteStatusChip.copyWith(
          color: isActive ? AppColors.mainColor : AppColors.grayText,
        ),
      ),
    );
  }
}
