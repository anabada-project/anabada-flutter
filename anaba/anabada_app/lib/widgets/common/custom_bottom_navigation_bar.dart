import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,

      currentIndex: currentIndex,

      selectedItemColor: AppColors.mainColor,
      unselectedItemColor: Colors.grey,

      selectedFontSize: 11,
      unselectedFontSize: 11,

      iconSize: 24,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: '메인페이지',
        ),

        BottomNavigationBarItem(icon: Icon(Icons.search), label: '물건 조회'),

        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: '물건 등록',
        ),

        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: '찜'),

        BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
      ],
    );
  }
}
