import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle noticeDetailHeaderTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle noticeDetailTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle noticeDetailInfo = TextStyle(
    fontSize: 14,
    color: AppColors.grayText,
  );

  static const TextStyle noticeDetailBody = TextStyle(
    fontSize: 16,
    height: 1.45,
    color: Colors.black,
  );

  static const TextStyle noticeDetailButton = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
