import 'package:flutter/material.dart';

import '../widgets/admin_notice_detail_bottom_button.dart';
import '../widgets/admin_notice_detail_content.dart';
import '../widgets/admin_notice_detail_header.dart';

class AdminNoticeDetailPage extends StatelessWidget {
  const AdminNoticeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              SizedBox(height: 20),

              AdminNoticeDetailHeader(),

              SizedBox(height: 42),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: AdminNoticeDetailContent(),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: AdminNoticeDetailBottomButton(),
    );
  }
}
