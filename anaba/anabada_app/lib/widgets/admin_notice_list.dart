import 'package:flutter/material.dart';

import 'admin_notice_tile.dart';

class AdminNoticeList extends StatelessWidget {
  const AdminNoticeList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 7,
      itemBuilder: (context, index) {
        return const AdminNoticeTile(
          title: '공지사항',
          content: '공지내용',
          time: '1일 전',
        );
      },
    );
  }
}
