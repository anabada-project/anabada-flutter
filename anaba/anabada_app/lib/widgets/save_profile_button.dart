import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class SaveProfileButton extends StatelessWidget {
  const SaveProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,

      child: ElevatedButton(
        onPressed: () {},

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainColor,
          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),

        child: const Text('저장하기', style: AppTextStyles.whiteButton),
      ),
    );
  }
}
