import 'package:flutter/material.dart';

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
          children: const [
            SizedBox(height: 20),
            MainPageTopBar(),
            SizedBox(height: 36),
            MainSectionTitle(title: '공지사항'),
            SizedBox(height: 14),
            MainNoticeBox(),
            SizedBox(height: 38),
            MainSectionTitle(title: '최근 올라온 물건'),
            SizedBox(height: 16),
            MainItemList(),
            SizedBox(height: 36),
            MainSectionTitle(title: '인기 물건'),
            SizedBox(height: 16),
            MainItemList(),
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
