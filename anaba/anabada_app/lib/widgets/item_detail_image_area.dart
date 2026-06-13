import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class ItemDetailImageArea extends StatelessWidget {
  const ItemDetailImageArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          color: const Color(0xFFF0F1F3),
        ),
        const SizedBox(height: 10),
        const _ImageIndicator(),
      ],
    );
  }
}

class _ImageIndicator extends StatelessWidget {
  const _ImageIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final bool isSelected = index == 0;

        return Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? AppColors.mainColor : const Color(0xFFE5E5E5),
          ),
        );
      }),
    );
  }
}
