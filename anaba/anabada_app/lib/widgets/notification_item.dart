import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final String time;

  const NotificationItem({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderGray),
            ),
            child: Icon(icon, size: 25, color: Colors.black),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.notificationItemTitle),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: AppTextStyles.notificationItemContent,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(time, style: AppTextStyles.notificationTime),
        ],
      ),
    );
  }
}
