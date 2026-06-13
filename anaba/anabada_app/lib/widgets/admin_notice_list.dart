import 'package:flutter/material.dart';

import '../pages/admin_notice_detail_page.dart';
import 'admin_notice_tile.dart';

class AdminNoticeList extends StatelessWidget {
  const AdminNoticeList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 7,
      itemBuilder: (context, index) {
        return AdminNoticeTile(
          title: '공지사항',
          content: '공지내용',
          time: '1일 전',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminNoticeDetailPage()),
            );
          },
        );
      },
    );
  }
}
