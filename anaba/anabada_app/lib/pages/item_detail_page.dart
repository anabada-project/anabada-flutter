import 'package:flutter/material.dart';

import '../widgets/item_detail_bottom_bar.dart';
import '../widgets/item_detail_comment_preview.dart';
import '../widgets/item_detail_header.dart';
import '../widgets/item_detail_image_area.dart';
import '../widgets/item_detail_info_section.dart';
import '../widgets/item_detail_not_found_state.dart';
import '../widgets/item_detail_wanted_section.dart';
import '../widgets/item_detail_writer_section.dart';
import 'item_detail_comment_page.dart';

enum ItemTradeType { exchange, sharing }

class ItemDetailPage extends StatefulWidget {
  final ItemTradeType tradeType;
  final bool initialIsLiked;
  final bool initialHasItem;

  const ItemDetailPage({
    super.key,
    required this.tradeType,
    required this.initialIsLiked,
    this.initialHasItem = true,
  });

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  late bool isLiked;
  late bool hasItem;

  @override
  void initState() {
    super.initState();

    isLiked = widget.initialIsLiked;
    hasItem = widget.initialHasItem;
  }

  String get requestButtonText {
    if (widget.tradeType == ItemTradeType.exchange) {
      return '교환 요청';
    }

    return '나눔 요청';
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void _handleRequest() {
    // TODO: 기능/API 연결 단계에서 요청 기능 구현
  }

  void _openCommentPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ItemDetailCommentPage()),
    );
  }

  void _goBackToList() {
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (!hasItem) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const ItemDetailHeader(),
              const ItemDetailImageArea(),
              Expanded(
                child: ItemDetailNotFoundState(onBackToListTap: _goBackToList),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: ItemDetailBottomBar(
        buttonText: requestButtonText,
        isLiked: isLiked,
        onRequestTap: _handleRequest,
        onLikeTap: _toggleLike,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ItemDetailHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const ItemDetailImageArea(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 28),
                          const ItemDetailInfoSection(),
                          const ItemDetailWriterSection(),
                          ItemDetailCommentPreview(onMoreTap: _openCommentPage),
                          const ItemDetailWantedSection(),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
