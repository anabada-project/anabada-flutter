import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/notice.dart';
import '../utils/time_formatter.dart';

class AdminNoticeDetailContent extends StatelessWidget {
  const AdminNoticeDetailContent({super.key, required this.notice});

  final Notice notice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(notice.title, style: AppTextStyles.adminNoticeDetailTitle),
        const SizedBox(height: 28),

        Text(
          '작성자 ${notice.author} | ${formatDateTime(notice.createdAt)}',
          style: AppTextStyles.adminNoticeDetailInfo,
        ),
        const SizedBox(height: 34),

        Container(height: 1, color: AppColors.borderGray),
        const SizedBox(height: 34),

        Text(notice.content, style: AppTextStyles.adminNoticeDetailContent),
      ],
    );
  }
}
