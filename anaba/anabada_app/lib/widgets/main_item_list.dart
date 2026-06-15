import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../models/trade_item.dart';
import '../pages/item_detail_page.dart';
import 'item_card.dart';

class MainItemList extends StatelessWidget {
  const MainItemList({super.key, this.popular = false});

  final bool popular;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appController,
      builder: (context, child) {
        final List<TradeItem> items = [...appController.items];
        if (popular) {
          items.sort((a, b) => b.likeCount.compareTo(a.likeCount));
        } else {
          items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }
        final List<TradeItem> visibleItems = items.take(5).toList();

        return SizedBox(
          height: 250,
          child: visibleItems.isEmpty
              ? const Center(child: Text('등록된 물건이 없습니다.'))
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: visibleItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final TradeItem item = visibleItems[index];
                    return ItemCard(
                      item: item,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ItemDetailPage(itemId: item.id),
                          ),
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
