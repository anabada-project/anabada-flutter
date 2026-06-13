import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';

class AdminNoticeDetailHeader extends StatelessWidget {
  const AdminNoticeDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              '공지사항',
              style: AppTextStyles.adminNoticeDetailHeaderTitle,
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 56),
              alignment: Alignment.centerLeft,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 22,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
