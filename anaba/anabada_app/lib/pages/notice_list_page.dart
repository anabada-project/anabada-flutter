import 'package:flutter/material.dart';
import '../widgets/notice_tile.dart';

class NoticeListPage extends StatelessWidget {
  const NoticeListPage({super.key});

  static const Color mainColor = Color(0xFFFFB800);
  static const Color grayText = Color(0xFF9E9E9E);

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

              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        '공지사항',

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 34,

                    child: ElevatedButton(
                      onPressed: () {},

                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),

                      child: const Text(
                        '+ 추가',

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,

                  children: const [
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

      bottomNavigationBar: _bottomNavigation(),
    );
  }

  Widget _bottomNavigation() {
    return Container(
      height: 84,

      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),

      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        currentIndex: 0,

        backgroundColor: Colors.white,
        elevation: 0,

        selectedItemColor: mainColor,
        unselectedItemColor: grayText,

        selectedFontSize: 11,
        unselectedFontSize: 11,

        iconSize: 24,

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

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: '찜',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
      ),
    );
  }
}
