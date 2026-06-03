import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';

class NotificationHeader extends StatelessWidget {
  const NotificationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text('알림', style: AppTextStyles.notificationHeaderTitle),
          ),

          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 32,
                height: 56,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 22,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
