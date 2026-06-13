import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/my_page_top_bar.dart';
import '../widgets/profile_card.dart';
import '../widgets/edit_profile_button.dart';
import '../widgets/my_page_section_title.dart';
import '../widgets/my_item_list.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;

    if (user == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text('로그인이 필요합니다.')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),

          children: [
            const SizedBox(height: 32),

            const MyPageTopBar(),

            const SizedBox(height: 24),

            ProfileCard(
              userName: user.name,
              email: user.email,
              major: user.major,
              generation: user.generation,
            ),

            const SizedBox(height: 16),

            const EditProfileButton(),

            const SizedBox(height: 36),

            const MyPageSectionTitle(title: '내가 등록한 물건'),

            const SizedBox(height: 16),

            const MyItemList(),

            const SizedBox(height: 28),

            const MyPageSectionTitle(title: '최근 조회한 물건'),

            const SizedBox(height: 16),

            const MyItemList(),

            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 4),
    );
  }
}
