import 'package:flutter/material.dart';

import 'notification_filter_tab.dart';

class NotificationFilterTabList extends StatelessWidget {
  const NotificationFilterTabList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: NotificationFilterTab(title: '전체', isSelected: true)),
        SizedBox(width: 8),
        Expanded(child: NotificationFilterTab(title: '요청', isSelected: false)),
        SizedBox(width: 8),
        Expanded(child: NotificationFilterTab(title: '댓글', isSelected: false)),
        SizedBox(width: 8),
        Expanded(child: NotificationFilterTab(title: '찜', isSelected: false)),
        SizedBox(width: 8),
        Expanded(child: NotificationFilterTab(title: '공지', isSelected: false)),
      ],
    );
  }
}
