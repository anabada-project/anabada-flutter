import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/item_card.dart';
import 'my_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          children: [
            const SizedBox(height: 20),

            // 상단바
            _topBar(),

            const SizedBox(height: 36),

            // 공지사항
            _sectionTitle('공지사항'),

            const SizedBox(height: 14),

            _noticeBox(),

            const SizedBox(height: 38),

            // 최근 올라온 물건
            _sectionTitle('최근 올라온 물건'),

            const SizedBox(height: 16),

            _itemList(),

            const SizedBox(height: 36),

            // 인기 물건
            _sectionTitle('인기 물건'),

            const SizedBox(height: 16),

            _itemList(),

            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: _bottomNavigation(context),
    );
  }

  // =========================
  // 상단바
  // =========================

  Widget _topBar() {
    return Row(
      children: [
        const Text(
          '아나바다',

          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),

        const Spacer(),

        IconButton(onPressed: () {}, icon: const Icon(Icons.search, size: 26)),

        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, size: 26),
        ),
      ],
    );
  }

  // =========================
  // 섹션 제목
  // =========================

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,

          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        const Spacer(),

        const Text(
          '더보기',

          style: TextStyle(color: AppColors.grayText, fontSize: 15),
        ),

        const SizedBox(width: 3),

        const Icon(Icons.chevron_right, color: AppColors.grayText),
      ],
    );
  }

  // =========================
  // 공지사항 박스
  // =========================

  Widget _noticeBox() {
    return Container(
      height: 100,

      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),

      decoration: BoxDecoration(
        color: Colors.white,

        border: Border.all(color: const Color(0xFFEAEAEA)),

        borderRadius: BorderRadius.circular(12),
      ),

      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          _NoticeRow(title: '공지 제목', time: '3시간 전'),

          _NoticeRow(title: '공지 제목', time: '1일 전'),

          _NoticeRow(title: '공지 제목', time: '2일 전'),
        ],
      ),
    );
  }

  // =========================
  // 물건 리스트
  // =========================

  Widget _itemList() {
    return SizedBox(
      height: 250,

      child: ListView.separated(
        scrollDirection: Axis.horizontal,

        itemCount: 5,

        separatorBuilder: (context, index) {
          return const SizedBox(width: 14);
        },

        itemBuilder: (context, index) {
          return ItemCard(
            status: index == 1 ? '교환 완료' : '교환 가능',

            isDone: index == 1,
          );
        },
      ),
    );
  }

  // =========================
  // 하단 네비게이션
  // =========================

  Widget _bottomNavigation(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,

      currentIndex: 0,

      selectedItemColor: AppColors.mainColor,
      unselectedItemColor: Colors.grey,

      onTap: (index) {
        // 마이페이지 이동
        if (index == 4) {
          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) => MyPage(
                userName: '이승준',
                email: 's26000@gsm.hs.kr',
                major: '플러터',
                generation: '10기',
              ),
            ),
          );
        }
      },

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: '메인페이지',
        ),

        BottomNavigationBarItem(icon: Icon(Icons.search), label: '물건 조회'),

        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: '물건 등록',
        ),

        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: '찜'),

        BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
      ],
    );
  }
}

// =========================
// 공지 한 줄
// =========================

class _NoticeRow extends StatelessWidget {
  final String title;
  final String time;

  const _NoticeRow({required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('•', style: TextStyle(fontSize: 16, color: Colors.black54)),

        const SizedBox(width: 10),

        Text(
          title,

          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),

        const Spacer(),

        Text(
          time,

          style: const TextStyle(fontSize: 15, color: AppColors.grayText),
        ),
      ],
    );
  }
}
