import 'package:flutter/material.dart';

import 'item_card.dart';

class MyItemList extends StatelessWidget {
  const MyItemList({super.key});

  @override
  Widget build(BuildContext context) {
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
}
