import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../models/trade_item.dart';
import '../pages/item_detail_page.dart';
import '../services/auth_service.dart';
import 'item_card.dart';

class MyItemList extends StatelessWidget {
  const MyItemList({super.key, required this.showRecent});

  final bool showRecent;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([appController, authService]),
      builder: (context, child) {
        final user = authService.currentUser;
        final List<TradeItem> items = user == null
            ? const []
            : showRecent
            ? appController.recentItems(user.id)
            : appController.userItems(user.id);

        return SizedBox(
          height: 250,
          child: items.isEmpty
              ? Center(
                  child: Text(
                    showRecent ? '최근 조회한 물건이 없습니다.' : '등록한 물건이 없습니다.',
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final TradeItem item = items[index];
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
