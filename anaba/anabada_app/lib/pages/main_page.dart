import 'package:flutter/material.dart';

import '../constants/app_routes.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';
import '../widgets/main_item_list.dart';
import '../widgets/main_notice_box.dart';
import '../widgets/main_page_top_bar.dart';
import '../widgets/main_section_title.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 20),
            const MainPageTopBar(),
            const SizedBox(height: 36),
            MainSectionTitle(
              title: '공지사항',
              onTap: () => Navigator.pushNamed(context, AppRoutes.notices),
            ),
            const SizedBox(height: 14),
            const MainNoticeBox(),
            const SizedBox(height: 38),
            MainSectionTitle(
              title: '최근 올라온 물건',
              onTap: () => Navigator.pushNamed(context, AppRoutes.itemList),
            ),
            const SizedBox(height: 16),
            const MainItemList(),
            const SizedBox(height: 36),
            MainSectionTitle(
              title: '인기 물건',
              onTap: () => Navigator.pushNamed(context, AppRoutes.itemList),
            ),
            const SizedBox(height: 16),
            const MainItemList(popular: true),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
