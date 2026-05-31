import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle favoriteHeaderTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle favoriteItemTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle favoriteItemAuthor = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.grayText,
  );

  static const TextStyle favoriteCategory = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.grayText,
  );

  static const TextStyle favoriteTime = TextStyle(
    fontSize: 15,
    color: AppColors.grayText,
  );

  static const TextStyle favoriteStatusActive = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.mainColor,
  );

  static const TextStyle favoriteStatusDone = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.grayText,
  );
}
