import 'package:flutter/material.dart';

import '../widgets/admin_main_item_list.dart';
import '../widgets/admin_main_section_title.dart';
import '../widgets/admin_main_top_bar.dart';
import '../widgets/admin_notice_preview.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';
import 'admin_notice_list_page.dart';
import 'admin_notice_write_page.dart';
import 'item_list_page.dart';

class AdminMainPage extends StatelessWidget {
  const AdminMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 36),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: AdminMainTopBar(),
            ),

            SizedBox(height: 46),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: AdminMainSectionTitle(
                title: '공지사항',
                showAddButton: true,
                onAddTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminNoticeWritePage(),
                    ),
                  );
                },
                onMoreTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminNoticeListPage(),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 12),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: AdminNoticePreview(),
            ),

            SizedBox(height: 44),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: AdminMainSectionTitle(
                title: '최근 올라온 물건',
                onMoreTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ItemListPage()),
                  );
                },
              ),
            ),

            SizedBox(height: 16),

            AdminMainItemList(),

            SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: AdminMainSectionTitle(
                title: '인기 물건',
                onMoreTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ItemListPage()),
                  );
                },
              ),
            ),

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
