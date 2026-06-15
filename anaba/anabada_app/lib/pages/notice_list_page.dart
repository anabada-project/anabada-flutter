import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../models/notice.dart';
import '../utils/time_formatter.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';
import '../widgets/notice_header.dart';
import '../widgets/notice_tile.dart';
import 'notice_detail_page.dart';

class NoticeListPage extends StatelessWidget {
  const NoticeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 18),

              const NoticeHeader(),

              const SizedBox(height: 20),

              Expanded(
                child: AnimatedBuilder(
                  animation: appController,
                  builder: (context, child) {
                    final List<Notice> notices = appController.notices;
                    if (notices.isEmpty) {
                      return const Center(child: Text('등록된 공지가 없습니다.'));
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: notices.length,
                      itemBuilder: (context, index) {
                        final Notice notice = notices[index];
                        return NoticeTile(
                          title: notice.title,
                          content: notice.content,
                          time: formatRelativeTime(notice.createdAt),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    NoticeDetailPage(noticeId: notice.id),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
