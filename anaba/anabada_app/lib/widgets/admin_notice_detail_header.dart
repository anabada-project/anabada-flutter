import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';

class AdminNoticeDetailHeader extends StatelessWidget {
  const AdminNoticeDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
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
              child: Text(
                '공지사항',
                style: AppTextStyles.adminNoticeDetailHeaderTitle,
              ),
            ),
          ),

          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
