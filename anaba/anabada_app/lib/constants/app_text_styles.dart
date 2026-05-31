import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle notificationHeaderTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle notificationSelectedTab = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle notificationTab = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: AppColors.grayText,
  );

  static const TextStyle notificationSectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle notificationItemTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle notificationItemContent = TextStyle(
    fontSize: 13,
    color: AppColors.grayText,
  );

  static const TextStyle notificationTime = TextStyle(
    fontSize: 13,
    color: AppColors.grayText,
  );
}
