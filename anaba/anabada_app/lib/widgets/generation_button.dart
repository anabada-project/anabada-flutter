import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class GenerationButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const GenerationButton({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: selected ? AppColors.mainColor : Colors.white,
          side: const BorderSide(color: AppColors.mainColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.mainColor,
          ),
        ),
      ),
    );
  }
}
