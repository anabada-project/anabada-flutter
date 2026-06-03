import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';
import '../widgets/favorite_item_card.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 44),
              const Center(
                child: Text('찜 목록', style: AppTextStyles.favoritePageTitle),
              ),
              const SizedBox(height: 44),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: const [
                    FavoriteItemCard(
                      title: '제목',
                      writer: '작성자',
                      category: '카테고리',
                      status: '교환 가능',
                      time: '3분 전',
                      isActive: true,
                    ),
                    SizedBox(height: 20),
                    FavoriteItemCard(
                      title: '제목',
                      writer: '작성자',
                      category: '카테고리',
                      status: '교환 완료',
                      time: '3분 전',
                      isActive: false,
                    ),
                    SizedBox(height: 20),
                    FavoriteItemCard(
                      title: '제목',
                      writer: '작성자',
                      category: '카테고리',
                      status: '나눔 완료',
                      time: '3분 전',
                      isActive: false,
                    ),
                    SizedBox(height: 20),
                    FavoriteItemCard(
                      title: '제목',
                      writer: '작성자',
                      category: '카테고리',
                      status: '나눔 가능',
                      time: '3분 전',
                      isActive: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 3),
    );
  }
}
