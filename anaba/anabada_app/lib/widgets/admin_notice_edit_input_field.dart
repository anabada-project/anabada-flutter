import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AdminNoticeEditInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;

  const AdminNoticeEditInputField({
    super.key,
    required this.label,
    required this.controller,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.adminNoticeEditLabel),
        const SizedBox(height: 12),
        SizedBox(
          height: 56,
          child: TextField(
            controller: controller,
            enabled: enabled,
            style: enabled
                ? AppTextStyles.adminNoticeEditInput
                : AppTextStyles.adminNoticeEditDisabledInput,
            decoration: InputDecoration(
              filled: true,
              fillColor: enabled ? Colors.white : AppColors.disabledButton,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderGray),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderGray),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.mainColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
