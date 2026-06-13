import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AdminNoticePreview extends StatelessWidget {
  const AdminNoticePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderGray),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _AdminNoticeRow(title: '공지 제목', time: '3시간 전'),
          _AdminNoticeRow(title: '공지 제목', time: '1일 전'),
          _AdminNoticeRow(title: '공지 제목', time: '2일 전'),
        ],
      ),
    );
  }
}

class _AdminNoticeRow extends StatelessWidget {
  const _AdminNoticeRow({required this.title, required this.time});

  final String title;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('•', style: AppTextStyles.adminNoticeTitle),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            title,
            style: AppTextStyles.adminNoticeTitle,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(width: 8),

        Text(time, style: AppTextStyles.adminNoticeTime),
      ],
    );
  }
}
