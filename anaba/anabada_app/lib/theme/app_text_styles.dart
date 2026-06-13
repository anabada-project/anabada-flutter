import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const TextStyle screenTitle = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle fieldLabel = TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle fieldHint = TextStyle(
    color: AppColors.grayText,
    fontSize: 12,
  );

  static const TextStyle fieldText = TextStyle(
    color: Colors.black,
    fontSize: 12,
  );

  static const TextStyle helperText = TextStyle(
    color: AppColors.grayText,
    fontSize: 11,
  );

  static const TextStyle buttonText = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle disabledButtonText = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle outlineButtonText = TextStyle(
    color: AppColors.mainColor,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
}
