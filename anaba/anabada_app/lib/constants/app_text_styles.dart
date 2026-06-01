import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle adminNoticeWriteHeaderTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle adminNoticeWriteLabel = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle adminNoticeWriteHint = TextStyle(
    fontSize: 15,
    color: AppColors.grayText,
  );

  static const TextStyle adminNoticeWriteButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.disabledText,
  );
}
