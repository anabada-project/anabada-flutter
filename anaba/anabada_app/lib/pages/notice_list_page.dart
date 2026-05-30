import 'package:flutter/material.dart';

import '../widgets/common/custom_bottom_navigation_bar.dart';
import '../widgets/notice_header.dart';
import '../widgets/notice_tile.dart';

class NoticeListPage extends StatelessWidget {
  const NoticeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              SizedBox(height: 18),

              NoticeHeader(),

              SizedBox(height: 20),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    NoticeTile(title: '공지사항', content: '공지내용'),
                    NoticeTile(title: '공지사항', content: '공지내용'),
                    NoticeTile(title: '공지사항', content: '공지내용'),
                    NoticeTile(title: '공지사항', content: '공지내용'),
                    NoticeTile(title: '공지사항', content: '공지내용'),
                    NoticeTile(title: '공지사항', content: '공지내용'),
                    NoticeTile(title: '공지사항', content: '공지내용'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
