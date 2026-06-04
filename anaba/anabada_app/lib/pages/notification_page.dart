import 'package:flutter/material.dart';

import '../widgets/common/custom_bottom_navigation_bar.dart';
import '../widgets/notification_filter_tab.dart';
import '../widgets/notification_header.dart';
import '../widgets/notification_item_tile.dart';
import '../widgets/notification_section_title.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 16),

              const NotificationHeader(),

              const SizedBox(height: 26),

              NotificationFilterTab(
                selectedIndex: selectedTabIndex,
                onTap: (index) {
                  setState(() {
                    selectedTabIndex = index;
                  });
                },
              ),

              const SizedBox(height: 24),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: const [
                    NotificationSectionTitle(title: '오늘'),

                    SizedBox(height: 18),

                    NotificationItemTile(
                      icon: Icons.favorite_border,
                      title: '찜 알림',
                      content: '게시글이름 을 찜했어요.',
                      time: '3분 전',
                    ),

                    NotificationItemTile(
                      icon: Icons.compare_arrows,
                      title: '교환 요청',
                      content: '게시글이름 에 대한 교환 요청이 도착했어요.',
                      time: '3분 전',
                    ),

                    NotificationItemTile(
                      icon: Icons.chat_bubble_outline,
                      title: '새 댓글',
                      content: '게시글이름 에 새로운 댓글이 달렸어요.',
                      time: '3분 전',
                    ),

                    NotificationItemTile(
                      icon: Icons.notifications_none,
                      title: '공지사항',
                      content: '공지내용',
                      time: '3분 전',
                    ),

                    SizedBox(height: 24),

                    NotificationSectionTitle(title: '이전 알림'),

                    SizedBox(height: 18),

                    NotificationItemTile(
                      icon: Icons.card_giftcard,
                      title: '나눔 요청',
                      content: '게시글이름 에 대한 나눔 요청이 도착했어요.',
                      time: '3분 전',
                    ),

                    NotificationItemTile(
                      icon: Icons.favorite_border,
                      title: '찜 알림',
                      content: '게시글이름 을 찜했어요.',
                      time: '3분 전',
                    ),

                    SizedBox(height: 16),
                  ],
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
