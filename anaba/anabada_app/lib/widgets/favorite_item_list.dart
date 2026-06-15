import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../models/trade_item.dart';
import '../pages/item_detail_page.dart';
import '../services/auth_service.dart';
import '../utils/time_formatter.dart';
import 'favorite_item_card.dart';

class FavoriteItemList extends StatelessWidget {
  const FavoriteItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([appController, authService]),
      builder: (context, child) {
        final user = authService.currentUser;
        final List<TradeItem> items = user == null
            ? const []
            : appController.favoriteItems(user.id);

        if (items.isEmpty) {
          return const Center(child: Text('찜한 물건이 없습니다.'));
        }

        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 24),
          itemBuilder: (context, index) {
            final TradeItem item = items[index];
            return FavoriteItemCard(
              item: item,
              time: formatRelativeTime(item.createdAt),
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
        );
      },
    );
  }
}
