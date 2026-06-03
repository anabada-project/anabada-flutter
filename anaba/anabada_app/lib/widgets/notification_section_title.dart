import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';

class NotificationSectionTitle extends StatelessWidget {
  final String title;

  const NotificationSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 18),
      child: Text(title, style: AppTextStyles.notificationSectionTitle),
    );
  }
}
