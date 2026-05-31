import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle adminMainTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle adminSectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle adminMoreText = TextStyle(
    fontSize: 14,
    color: AppColors.grayText,
  );

  static const TextStyle adminNoticeTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle adminNoticeTime = TextStyle(
    fontSize: 14,
    color: AppColors.grayText,
  );

  static const TextStyle adminItemTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle adminItemDescription = TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );

  static const TextStyle adminItemLike = TextStyle(
    fontSize: 14,
    color: AppColors.grayText,
  );

  static const TextStyle adminItemStatusActive = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.mainColor,
  );

  static const TextStyle adminItemStatusDone = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.grayText,
  );
}
