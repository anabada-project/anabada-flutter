import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
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

        SizedBox(
          height: 34,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text('+ 추가', style: AppTextStyles.whiteButton),
          ),
        ),
      ],
    );
  }
}
