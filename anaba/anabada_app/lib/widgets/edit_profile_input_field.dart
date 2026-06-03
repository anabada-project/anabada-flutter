import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class EditProfileInputField extends StatelessWidget {
  const EditProfileInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.enabled = true,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(label, style: AppTextStyles.editLabel),

        const SizedBox(height: 10),

        TextField(
          enabled: enabled,
          controller: controller,

          decoration: InputDecoration(
            hintText: hintText,

            hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),

            filled: true,
            fillColor: enabled ? Colors.white : const Color(0xFFF4F4F4),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),

            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFDADADA)),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFDADADA)),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.mainColor),
            ),
          ),
        ),
      ],
    );
  }
}
