import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../models/trade_item.dart';
import 'admin_main_item_card.dart';

class AdminMainItemList extends StatelessWidget {
  const AdminMainItemList({super.key, this.popular = false});

  final bool popular;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appController,
      builder: (context, child) {
        final List<TradeItem> items = [...appController.items];
        items.sort(
          popular
              ? (a, b) => b.likeCount.compareTo(a.likeCount)
              : (a, b) => b.createdAt.compareTo(a.createdAt),
        );
        final visibleItems = items.take(5).toList();

        return SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            itemCount: visibleItems.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return AdminMainItemCard(item: visibleItems[index]);
            },
          ),
        );
      },
    );
  }
}
