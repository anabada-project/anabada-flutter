import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';

class AdminMainTopBar extends StatelessWidget {
  const AdminMainTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('아나바다', style: AppTextStyles.adminMainTitle),

        const Spacer(),

        IconButton(onPressed: () {}, icon: const Icon(Icons.search, size: 26)),

        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, size: 26),
        ),
      ],
    );
  }
}
