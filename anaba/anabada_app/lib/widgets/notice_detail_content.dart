import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/notice.dart';
import '../utils/time_formatter.dart';

class NoticeDetailContent extends StatelessWidget {
  const NoticeDetailContent({super.key, required this.notice});

  final Notice notice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(notice.title, style: AppTextStyles.noticeDetailTitle),

        const SizedBox(height: 22),

        Text(
          '작성자 ${notice.author} | ${formatDateTime(notice.createdAt)}',
          style: AppTextStyles.noticeDetailInfo,
        ),

        const SizedBox(height: 34),

        const Divider(height: 1, thickness: 1, color: AppColors.borderGray),

        const SizedBox(height: 40),

        Text(notice.content, style: AppTextStyles.noticeDetailBody),
      ],
    );
  }
}
