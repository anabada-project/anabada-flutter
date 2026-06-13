import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';

class NotificationSectionTitle extends StatelessWidget {
  const NotificationSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: AppTextStyles.notificationSectionTitle),
    );
  }
}
