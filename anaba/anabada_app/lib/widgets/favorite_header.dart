import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';

class FavoriteHeader extends StatelessWidget {
  const FavoriteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 44,
      child: Center(
        child: Text('찜 목록', style: AppTextStyles.favoriteHeaderTitle),
      ),
    );
  }
}
