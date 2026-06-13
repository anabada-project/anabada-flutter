import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AdminNoticeTile extends StatelessWidget {
  const AdminNoticeTile({
    super.key,
    required this.title,
    required this.content,
    required this.time,
  });

  final String title;
  final String content;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 104),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderGray, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderGray),
            ),
            child: const Icon(Icons.campaign, size: 20, color: Colors.black87),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.adminNoticeTitle,
                ),

                const SizedBox(height: 8),

                Text(
                  content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.adminNoticeContent,
                ),

                const SizedBox(height: 8),

                Text(time, style: AppTextStyles.adminNoticeTime),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
