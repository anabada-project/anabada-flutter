import 'package:flutter/material.dart';

import '../widgets/common/custom_bottom_navigation_bar.dart';
import '../widgets/favorite_header.dart';
import '../widgets/favorite_item_list.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              SizedBox(height: 44),

              FavoriteHeader(),

              SizedBox(height: 48),

              Expanded(child: FavoriteItemList()),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 3),
    );
  }
}
