import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key, required this.currentIndex});

  final int currentIndex;

  void _handleTap(BuildContext context, int index) {
    if (index == currentIndex) {
      return;
    }

    String? routeName;

    switch (index) {
      case 0:
        routeName = AppRoutes.main;
      case 3:
        routeName = AppRoutes.favorite;
      case 4:
        routeName = AppRoutes.myPage;
    }

    if (routeName == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('아직 준비 중인 화면입니다.')));
      return;
    }

    Navigator.of(context).pushReplacementNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 12,
            offset: Offset(0, -4),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) => _handleTap(context, index),
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: AppColors.grayText,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: '찜',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
      ),
    );
  }
}
