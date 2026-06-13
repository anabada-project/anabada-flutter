import 'package:flutter/material.dart';

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
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return NoticeTile(
                      title: '공지사항',
                      content: '공지내용',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NoticeDetailPage(),
                          ),
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
