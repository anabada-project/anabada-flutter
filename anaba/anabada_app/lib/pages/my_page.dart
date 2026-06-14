import 'package:flutter/material.dart';

import '../pages/edit_profile_page.dart';
import '../services/auth_service.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';
import '../widgets/edit_profile_button.dart';
import '../widgets/my_item_list.dart';
import '../widgets/my_page_section_title.dart';
import '../widgets/my_page_top_bar.dart';
import '../widgets/profile_card.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late String userName;
  late String email;
  late String major;
  late String generation;

  @override
  void initState() {
    super.initState();

    final user = authService.currentUser;

    userName = user?.name ?? '';
    email = user?.email ?? '';
    major = user?.major ?? '';
    generation = user?.generation ?? '';
  }

  void _updateProfile(EditProfileResult result) {
    setState(() {
      userName = result.name;
      email = result.email;
      major = result.major;
      generation = result.generation;
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('프로필 정보가 마이페이지에 반영되었습니다.')));
  }

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
              userName: userName,
              email: email,
              major: major,
              generation: generation,
            ),

            const SizedBox(height: 16),

            EditProfileButton(
              name: userName,
              email: email,
              major: major,
              generation: generation,
              onProfileUpdated: _updateProfile,
            ),

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
