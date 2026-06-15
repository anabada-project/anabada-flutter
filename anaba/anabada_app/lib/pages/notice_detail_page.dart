import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../widgets/notice_detail_bottom_button.dart';
import '../widgets/notice_detail_content.dart';
import '../widgets/notice_detail_header.dart';

class NoticeDetailPage extends StatelessWidget {
  const NoticeDetailPage({super.key, required this.noticeId});

  final String noticeId;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appController,
      builder: (context, child) {
        final notice = appController.noticeById(noticeId);
        if (notice == null) {
          return const Scaffold(body: Center(child: Text('공지를 찾을 수 없습니다.')));
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  const NoticeDetailHeader(),
                  const SizedBox(height: 54),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: NoticeDetailContent(notice: notice),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const NoticeDetailBottomButton(),
        );
      },
    );
  }
}
