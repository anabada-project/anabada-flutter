import 'package:flutter/material.dart';

import '../widgets/item_card.dart';

class MyPage extends StatelessWidget {
  const MyPage({
    super.key,
    required this.userName,
    required this.email,
    required this.major,
    required this.generation,
  });

  // 외부에서 받아오는 데이터
  final String userName;
  final String email;
  final String major;
  final String generation;

  // 색상
  static const Color mainColor = Color(0xFFFFB800);
  static const Color grayText = Color(0xFF9E9E9E);

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

            const SizedBox(height: 24),

            // 프로필 카드
            _profileCard(),

            const SizedBox(height: 16),

            // 정보 수정 버튼
            _editButton(),

            const SizedBox(height: 36),

            // 내가 등록한 물건
            _sectionTitle('내가 등록한 물건'),

            const SizedBox(height: 16),

            _itemList(),

            const SizedBox(height: 36),

            // 최근 조회한 물건
            _sectionTitle('최근 조회한 물건'),

            const SizedBox(height: 16),

            _itemList(),

            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: _bottomNavigation(),
    );
  }

  // 상단바
  Widget _topBar() {
    return Row(
      children: [
        const Text(
          '마이페이지',

          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),

        const Spacer(),

        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),

        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }

  // 프로필 카드
  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEAEAEA)),

        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [
          const CircleAvatar(
            radius: 38,
            backgroundColor: Color(0xFFE4E4E4),

            child: Icon(Icons.person, size: 55, color: Colors.white),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // 이름
                Text(
                  userName,

                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // 이메일
                Text(
                  email,

                  style: const TextStyle(color: grayText, fontSize: 15),
                ),

                const SizedBox(height: 4),

                // 전공
                Text(
                  major,

                  style: const TextStyle(color: grayText, fontSize: 15),
                ),
              ],
            ),
          ),

          // 기수
          Text(
            generation,

            style: const TextStyle(color: grayText, fontSize: 15),
          ),
        ],
      ),
    );
  }

  // 정보 수정 버튼
  Widget _editButton() {
    return SizedBox(
      height: 50,

      child: OutlinedButton(
        onPressed: () {},

        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: mainColor),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),

        child: const Text(
          '정보 수정',

          style: TextStyle(
            color: mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // 섹션 제목
  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,

          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        const Spacer(),

        const Text('더보기', style: TextStyle(color: grayText)),

        const SizedBox(width: 3),

        const Icon(Icons.chevron_right, color: grayText),
      ],
    );
  }

  // 가로 스크롤 물건 리스트
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

  // 하단 네비게이션
  Widget _bottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,

      currentIndex: 4,

      selectedItemColor: mainColor,
      unselectedItemColor: Colors.grey,

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
