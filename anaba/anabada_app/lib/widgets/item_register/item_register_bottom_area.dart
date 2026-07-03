import 'package:flutter/material.dart';

import 'item_register_colors.dart';

class ItemRegisterSubmitButton extends StatelessWidget {
  const ItemRegisterSubmitButton({
    super.key,
    required this.isActive,
    required this.isLoading,
    required this.onTap,
  });

  final bool isActive;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 43,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive
              ? ItemRegisterColors.mainColor
              : ItemRegisterColors.disabledButtonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: isLoading
            ? const SizedBox(
                width: 19,
                height: 19,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                '등록하기',
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFFA8A8A8),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

class ItemRegisterBottomArea extends StatelessWidget {
  const ItemRegisterBottomArea({
    super.key,
    required this.isRegisterButtonActive,
    required this.isLoading,
    required this.currentIndex,
    required this.onRegisterTap,
    required this.onNavigationTap,
  });

  final bool isRegisterButtonActive;
  final bool isLoading;
  final int currentIndex;
  final VoidCallback onRegisterTap;
  final ValueChanged<int> onNavigationTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ItemRegisterSubmitButton(
                isActive: isRegisterButtonActive,
                isLoading: isLoading,
                onTap: onRegisterTap,
              ),
            ),
            const SizedBox(height: 18),
            ItemRegisterBottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onNavigationTap,
            ),
          ],
        ),
      ),
    );
  }
}

class ItemRegisterBottomNavigationBar extends StatelessWidget {
  const ItemRegisterBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: ItemRegisterColors.mainColor,
        unselectedItemColor: const Color(0xFFA8A8A8),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 24),
            label: '메인페이지',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 24),
            label: '물건 조회',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 25),
            label: '물건 등록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, size: 24),
            label: '찜',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}
