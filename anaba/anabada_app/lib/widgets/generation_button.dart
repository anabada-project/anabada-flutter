import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class GenerationButton extends StatelessWidget {
  const GenerationButton({
    super.key,
    required this.text,
    required this.selected,
  });

  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 48,

        child: OutlinedButton(
          onPressed: () {},

          style: OutlinedButton.styleFrom(
            backgroundColor: selected ? AppColors.mainColor : Colors.white,

            side: const BorderSide(color: AppColors.mainColor),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          child: Text(
            text,
            style: selected
                ? AppTextStyles.whiteButton
                : AppTextStyles.editButton,
          ),
        ),
      ),
    );
  }
}
