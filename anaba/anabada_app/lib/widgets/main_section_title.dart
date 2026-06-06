import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class MainSectionTitle extends StatelessWidget {
  const MainSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppTextStyles.sectionTitle),

        const Spacer(),

        const Text('더보기', style: AppTextStyles.moreText),

        const SizedBox(width: 3),

        const Icon(Icons.chevron_right, color: AppColors.grayText),
      ],
    );
  }
}
