import 'package:flutter/material.dart';

import '../widgets/notice_detail_bottom_button.dart';
import '../widgets/notice_detail_content.dart';
import '../widgets/notice_detail_header.dart';

class NoticeDetailPage extends StatelessWidget {
  const NoticeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              SizedBox(height: 24),

              NoticeDetailHeader(),

              SizedBox(height: 54),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: NoticeDetailContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: NoticeDetailBottomButton(),
    );
  }
}
