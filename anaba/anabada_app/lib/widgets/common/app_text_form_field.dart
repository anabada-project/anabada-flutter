import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.errorText,
    this.enabled = true,
    this.fillColor,
  });

  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool enabled;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    // ✅ Fix: always fill when disabled OR when fillColor is explicitly set
    final bool shouldFill = fillColor != null || !enabled;
    final Color effectiveFillColor = fillColor ?? const Color(0xFFF6F7F8);

    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      style: AppTextStyles.fieldText,
      cursorColor: AppColors.mainColor,
      decoration: InputDecoration(
        isDense: true,
        filled: shouldFill,
        fillColor: effectiveFillColor,
        hintText: hintText,
        errorText: errorText,
        errorMaxLines: 2,
        hintStyle: AppTextStyles.fieldHint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.mainColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}
