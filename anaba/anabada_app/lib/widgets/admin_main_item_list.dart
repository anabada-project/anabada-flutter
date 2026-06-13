import 'package:flutter/material.dart';

import 'admin_main_item_card.dart';

class AdminMainItemList extends StatelessWidget {
  const AdminMainItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        itemCount: 5,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 14);
        },
        itemBuilder: (context, index) {
          const statuses = ['교환 가능', '교환 완료', '교환 가능', '나눔 가능', '나눔 완료'];

          return AdminMainItemCard(
            status: statuses[index],
            isDone: statuses[index].contains('완료'),
          );
        },
      ),
    );
  }
}
