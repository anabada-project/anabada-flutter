import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle pageTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle moreText = TextStyle(
    fontSize: 15,
    color: AppColors.grayText,
  );

  static const TextStyle noticeDot = TextStyle(
    fontSize: 16,
    color: Colors.black54,
  );

  static const TextStyle noticeTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.black54,
  );

  static const TextStyle noticeTime = TextStyle(
    fontSize: 15,
    color: AppColors.grayText,
  );
}
