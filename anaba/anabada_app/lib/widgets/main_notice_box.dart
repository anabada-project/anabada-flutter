import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';
import '../controllers/app_controller.dart';
import '../models/notice.dart';
import '../pages/notice_detail_page.dart';
import '../utils/time_formatter.dart';

class MainNoticeBox extends StatelessWidget {
  const MainNoticeBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appController,
      builder: (context, child) {
        final List<Notice> notices = appController.notices.take(3).toList();
        return Container(
          constraints: const BoxConstraints(minHeight: 100),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFEAEAEA)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: notices.isEmpty
              ? const Center(child: Text('등록된 공지가 없습니다.'))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: notices.map((notice) {
                    return NoticeRow(
                      title: notice.title,
                      time: formatRelativeTime(notice.createdAt),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                NoticeDetailPage(noticeId: notice.id),
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

class NoticeRow extends StatelessWidget {
  const NoticeRow({
    super.key,
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
          const Text('•', style: AppTextStyles.noticeDot),
          const SizedBox(width: 10),
          Text(title, style: AppTextStyles.noticeTitle),
          const Spacer(),
          Text(time, style: AppTextStyles.noticeTime),
        ],
      ),
    );
  }
}
