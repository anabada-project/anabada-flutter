import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AdminNoticeTitleField extends StatelessWidget {
  const AdminNoticeTitleField({
    super.key,
    required this.label,
    required this.hintText,
    this.readOnly = false,
  });

  final String label;
  final String hintText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.adminNoticeWriteLabel),

        const SizedBox(height: 12),

        SizedBox(
          height: 44,
          child: TextField(
            readOnly: readOnly,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.adminNoticeWriteHint,
              filled: readOnly,
              fillColor: readOnly ? AppColors.lightGray : Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.borderGray),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.mainColor),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
