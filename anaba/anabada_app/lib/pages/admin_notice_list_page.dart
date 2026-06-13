import 'package:flutter/material.dart';

import '../widgets/admin_notice_header.dart';
import '../widgets/admin_notice_list.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';

class AdminNoticeListPage extends StatelessWidget {
  const AdminNoticeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              SizedBox(height: 14),

              AdminNoticeHeader(),

              SizedBox(height: 18),

              Expanded(child: AdminNoticeList()),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
