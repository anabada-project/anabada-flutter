import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class ItemDetailNotFoundState extends StatelessWidget {
  final VoidCallback onBackToListTap;

  const ItemDetailNotFoundState({super.key, required this.onBackToListTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const Spacer(),

          const Icon(
            Icons.file_copy_outlined,
            size: 82,
            color: Color(0xFFBDBDBD),
          ),

          const SizedBox(height: 24),

          const Text(
            '물건 정보를 확인할 수 없습니다.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            '존재하지 않거나 정보를 불러올 수 없습니다.\n잠시 후 다시 시도해주세요.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: Color(0xFF8E8E8E),
            ),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onBackToListTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                '목록으로 돌아가기',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
