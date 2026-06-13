import 'package:flutter/material.dart';

import '../constants/app_routes.dart';
import '../constants/app_text_styles.dart';

class MyPageTopBar extends StatelessWidget {
  const MyPageTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('마이페이지', style: AppTextStyles.pageTitle),

        const Spacer(),

        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.itemList);
          },
          icon: const Icon(Icons.search),
        ),

        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.notifications);
          },
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }
}
