import 'package:flutter/material.dart';

import '../widgets/admin_main_item_list.dart';
import '../widgets/admin_main_section_title.dart';
import '../widgets/admin_main_top_bar.dart';
import '../widgets/admin_notice_preview.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';

class AdminMainPage extends StatelessWidget {
  const AdminMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          children: [
            SizedBox(height: 36),

            AdminMainTopBar(),

            SizedBox(height: 46),

            AdminMainSectionTitle(title: '공지사항', showAddButton: true),

            SizedBox(height: 12),

            AdminNoticePreview(),

            SizedBox(height: 44),

            AdminMainSectionTitle(title: '최근 올라온 물건'),

            SizedBox(height: 16),

            AdminMainItemList(),

            SizedBox(height: 40),

            AdminMainSectionTitle(title: '인기 물건'),

            SizedBox(height: 16),

            AdminMainItemList(),

            SizedBox(height: 24),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
