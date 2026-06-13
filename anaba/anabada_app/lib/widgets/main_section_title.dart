import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class MainSectionTitle extends StatelessWidget {
  const MainSectionTitle({super.key, required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Text(title, style: AppTextStyles.sectionTitle),
            const Spacer(),
            const Text('더보기', style: AppTextStyles.moreText),
            const SizedBox(width: 3),
            const Icon(Icons.chevron_right, color: AppColors.grayText),
          ],
        ),
      ),
    );
  }
}
