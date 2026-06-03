import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AdminNoticeDetailBottomButton extends StatelessWidget {
  const AdminNoticeDetailBottomButton({super.key});

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
              Navigator.maybePop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: const Text(
              '목록으로',
              style: AppTextStyles.adminNoticeDetailButton,
            ),
          ),
        ),
      ),
    );
  }
}
