import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';

class NotificationHeader extends StatelessWidget {
  const NotificationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          ),
          const Expanded(
            child: Center(
              child: Text('알림', style: AppTextStyles.notificationHeaderTitle),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
