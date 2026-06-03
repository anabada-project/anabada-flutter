import 'package:flutter/material.dart';
import 'pages/my_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 왼쪽 디버그 지우는 코드

      home: MyPage(
        // 더미데이터
        userName: '이승준',
        email: 's26000@gsm.hs.kr',
        major: '플러터',
        generation: '10기',
      ),
    );
  }
}
