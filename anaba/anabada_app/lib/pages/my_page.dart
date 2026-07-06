import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
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
  String? _loadedUserId;
  bool _isLoadingAccount = false;

  void _scheduleAccountLoad(String userId) {
    _loadedUserId = userId;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _isLoadingAccount) return;

      _isLoadingAccount = true;
      try {
        final refreshedUser = await authService.refreshCurrentUserWithApi();
        final String effectiveUserId = refreshedUser?.id ?? userId;
        await appController.fetchUserItems(effectiveUserId);
      } catch (error) {
        debugPrint('Account API load failed: $error');
      } finally {
        _isLoadingAccount = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: authService,
      builder: (context, child) {
        final user = authService.currentUser;
        if (user == null) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text('로그인이 필요합니다.')),
          );
        }

        if (_loadedUserId != user.id) {
          _scheduleAccountLoad(user.id);
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
                EditProfileButton(
                  name: user.name,
                  email: user.email,
                  major: user.major,
                  generation: user.generation,
                  onProfileUpdated: (_) {
                    ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(
                        const SnackBar(content: Text('프로필 정보가 저장되었습니다.')),
                      );
                  },
                ),
                const SizedBox(height: 36),
                const MyPageSectionTitle(title: '내가 등록한 물건'),
                const SizedBox(height: 16),
                const MyItemList(showRecent: false),
                const SizedBox(height: 28),
                const MyPageSectionTitle(title: '최근 조회한 물건'),
                const SizedBox(height: 16),
                const MyItemList(showRecent: true),
                const SizedBox(height: 30),
              ],
            ),
          ),
          bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 4),
        );
      },
    );
  }
}
