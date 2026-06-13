import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class NoticeDetailBottomButton extends StatelessWidget {
  const NoticeDetailBottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, bottom: 12),
        child: SizedBox(
          width: double.infinity,
          height: 43,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            child: const Text('목록으로', style: AppTextStyles.noticeDetailButton),
          ),
        ),
      ),
    );
  }
}
