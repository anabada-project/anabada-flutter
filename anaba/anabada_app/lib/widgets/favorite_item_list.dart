import 'package:flutter/material.dart';

import '../pages/item_detail_page.dart';
import 'favorite_item_card.dart';

class FavoriteItemList extends StatelessWidget {
  const FavoriteItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 4,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 24);
      },
      itemBuilder: (context, index) {
        const statuses = ['교환 가능', '교환 완료', '나눔 완료', '나눔 가능'];

        return FavoriteItemCard(
          title: '제목',
          author: '작성자',
          category: '카테고리',
          status: statuses[index],
          time: '3분 전',
          isActive: index == 0 || index == 3,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ItemDetailPage(
                  tradeType: statuses[index].contains('나눔')
                      ? ItemTradeType.sharing
                      : ItemTradeType.exchange,
                  initialIsLiked: true,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
