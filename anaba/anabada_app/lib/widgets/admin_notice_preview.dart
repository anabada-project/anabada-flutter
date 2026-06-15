import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../controllers/app_controller.dart';
import '../models/notice.dart';
import '../pages/admin_notice_detail_page.dart';
import '../utils/time_formatter.dart';

class AdminNoticePreview extends StatelessWidget {
  const AdminNoticePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appController,
      builder: (context, child) {
        final List<Notice> notices = appController.notices.take(3).toList();
        return Container(
          constraints: const BoxConstraints(minHeight: 120),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.borderGray),
            borderRadius: BorderRadius.circular(8),
          ),
          child: notices.isEmpty
              ? const Center(child: Text('등록된 공지가 없습니다.'))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: notices.map((notice) {
                    return _AdminNoticeRow(
                      title: notice.title,
                      time: formatRelativeTime(notice.createdAt),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AdminNoticeDetailPage(noticeId: notice.id),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
        );
      },
    );
  }
}

class _AdminNoticeRow extends StatelessWidget {
  const _AdminNoticeRow({
    required this.title,
    required this.time,
    required this.onTap,
  });

  final String title;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
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
      ),
    );
  }
}
