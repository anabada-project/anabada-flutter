import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class NotificationFilterTab extends StatelessWidget {
  final String title;
  final bool isSelected;

  const NotificationFilterTab({
    super.key,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.mainColor : AppColors.disabledButton,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        style: isSelected
            ? AppTextStyles.selectedNotificationTab
            : AppTextStyles.notificationTab,
      ),
    );
  }
}
