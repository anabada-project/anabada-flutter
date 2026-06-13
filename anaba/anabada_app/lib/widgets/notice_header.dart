import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';

class NoticeHeader extends StatelessWidget {
  const NoticeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, size: 22),
        ),

        const Expanded(
          child: Center(
            child: Text('공지사항', style: AppTextStyles.editPageTitle),
          ),
        ),

        const SizedBox(width: 48),
      ],
    );
  }
}
