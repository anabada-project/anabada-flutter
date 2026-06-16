import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../models/notice.dart';
import '../pages/admin_notice_detail_page.dart';
import '../utils/time_formatter.dart';
import 'admin_notice_tile.dart';

class AdminNoticeList extends StatelessWidget {
  const AdminNoticeList({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appController,
      builder: (context, child) {
        final List<Notice> notices = appController.notices;
        if (notices.isEmpty) {
          return const Center(child: Text('등록된 공지가 없습니다.'));
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: notices.length,
          itemBuilder: (context, index) {
            final Notice notice = notices[index];
            return AdminNoticeTile(
              title: notice.title,
              content: notice.content,
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
          },
        );
      },
    );
  }
}
