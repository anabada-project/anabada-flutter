import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class NotificationFilterTab extends StatelessWidget {
  const NotificationFilterTab({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const List<String> tabs = ['전체', '요청', '댓글', '찜', '공지'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(tabs.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == tabs.length - 1 ? 0 : 8),
            child: _FilterButton(
              text: tabs[index],
              selected: selectedIndex == index,
              onTap: () {
                onTap(index);
              },
            ),
          ),
        );
      }),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.mainColor : AppColors.lightGray,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: selected
              ? AppTextStyles.notificationSelectedTab
              : AppTextStyles.notificationTab,
        ),
      ),
    );
  }
}
