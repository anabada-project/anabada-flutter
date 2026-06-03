import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle adminNoticeDetailHeaderTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle adminNoticeDetailTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle adminNoticeDetailInfo = TextStyle(
    fontSize: 12,
    color: AppColors.grayText,
  );

  static const TextStyle adminNoticeDetailContent = TextStyle(
    fontSize: 13,
    height: 1.45,
    color: Colors.black,
  );

  static const TextStyle adminNoticeDetailButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
