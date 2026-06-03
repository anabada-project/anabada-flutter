import 'package:flutter/material.dart';

import 'notification_filter_tab.dart';

class NotificationFilterTabList extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const NotificationFilterTabList({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['전체', '요청', '댓글', '찜', '공지'];

    return Row(
      children: List.generate(tabs.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == tabs.length - 1 ? 0 : 8),
            child: NotificationFilterTab(
              title: tabs[index],
              isSelected: selectedIndex == index,
              onTap: () {
                onTabSelected(index);
              },
            ),
          ),
        );
      }),
    );
  }
}
