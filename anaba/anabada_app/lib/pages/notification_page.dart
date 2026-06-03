import 'package:flutter/material.dart';

import '../widgets/common/custom_bottom_navigation_bar.dart';
import '../widgets/notification_filter_tab_list.dart';
import '../widgets/notification_header.dart';
import '../widgets/notification_item.dart';
import '../widgets/notification_section_title.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const NotificationHeader(),
              const SizedBox(height: 24),
              const NotificationFilterTabList(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: const [
                    NotificationSectionTitle(title: '오늘'),
                    NotificationItem(
                      icon: Icons.favorite_border,
                      title: '찜 알림',
                      content: '게시글이름 을 찜했어요.',
                      time: '3분 전',
                    ),
                    NotificationItem(
                      icon: Icons.swap_horiz,
                      title: '교환 요청',
                      content: '게시글이름 에 대한 교환 요청이 도착했어요.',
                      time: '3분 전',
                    ),
                    NotificationItem(
                      icon: Icons.chat_bubble_outline,
                      title: '새 댓글',
                      content: '게시글이름 에 새로운 댓글이 달렸어요.',
                      time: '3분 전',
                    ),
                    NotificationItem(
                      icon: Icons.notifications_none,
                      title: '공지사항',
                      content: '공지내용',
                      time: '3분 전',
                    ),
                    NotificationSectionTitle(title: '이전 알림'),
                    NotificationItem(
                      icon: Icons.card_giftcard,
                      title: '나눔 요청',
                      content: '게시글이름 에 대한 나눔 요청이 도착했어요.',
                      time: '3분 전',
                    ),
                    NotificationItem(
                      icon: Icons.favorite_border,
                      title: '찜 알림',
                      content: '게시글이름 을 찜했어요.',
                      time: '3분 전',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}
