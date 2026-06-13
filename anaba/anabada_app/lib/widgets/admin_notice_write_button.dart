import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AdminNoticeWriteButton extends StatelessWidget {
  const AdminNoticeWriteButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, bottom: 12),
        child: SizedBox(
          width: double.infinity,
          height: 43,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              disabledBackgroundColor: AppColors.disabledButton,
              disabledForegroundColor: AppColors.disabledText,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            child: const Text(
              '등록하기',
              style: AppTextStyles.adminNoticeWriteButton,
            ),
          ),
        ),
      ),
    );
  }
}
