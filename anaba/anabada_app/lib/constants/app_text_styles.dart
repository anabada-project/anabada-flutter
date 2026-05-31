import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle adminNoticeHeaderTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle adminNoticeAddButton = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle adminNoticeTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle adminNoticeContent = TextStyle(
    fontSize: 13,
    color: AppColors.grayText,
  );

  static const TextStyle adminNoticeTime = TextStyle(
    fontSize: 13,
    color: AppColors.grayText,
  );
}
