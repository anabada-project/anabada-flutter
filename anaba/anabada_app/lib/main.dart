import 'package:flutter/material.dart';

import 'constants/app_routes.dart';
import 'pages/favorite_page.dart';
import 'pages/item_list_page.dart';
import 'pages/main_page.dart';
import 'pages/my_page.dart';
import 'pages/notice_list_page.dart';
import 'pages/notification_page.dart';
import 'screen/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Login(),
      routes: {
        AppRoutes.main: (_) => const MainPage(),
        AppRoutes.itemList: (_) => const ItemListPage(),
        AppRoutes.favorite: (_) => const FavoritePage(),
        AppRoutes.myPage: (_) => const MyPage(),
        AppRoutes.notifications: (_) => const NotificationPage(),
        AppRoutes.notices: (_) => const NoticeListPage(),
      },
    );
  }
}
