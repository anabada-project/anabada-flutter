import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../models/trade_item.dart';
import '../models/trade_request.dart';
import '../services/auth_service.dart';
import '../widgets/item_detail_bottom_bar.dart';
import '../widgets/item_detail_comment_preview.dart';
import '../widgets/item_detail_header.dart';
import '../widgets/item_detail_image_area.dart';
import '../widgets/item_detail_info_section.dart';
import '../widgets/item_detail_not_found_state.dart';
import '../widgets/item_detail_wanted_section.dart';
import '../widgets/item_detail_writer_section.dart';
import 'item_detail_comment_page.dart';

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
  const ItemDetailPage({super.key, required this.itemId});

  final String itemId;

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
  @override
  void initState() {
    super.initState();
    final user = authService.currentUser;
    if (user != null) {
      appController.recordItemView(itemId: widget.itemId, userId: user.id);
    }
  }

  Future<void> _toggleLike() async {
    final user = authService.currentUser;
    if (user == null) return;

    await appController.toggleLike(
      itemId: widget.itemId,
      userId: user.id,
      userName: user.name,
    );
  }

  Future<void> _handleRequest() async {
    final user = authService.currentUser;
    if (user == null) return;

    try {
      await appController.createTradeRequest(
        itemId: widget.itemId,
        requesterId: user.id,
        requesterName: user.name,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('거래 요청을 보냈습니다.')));
    } on StateError catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    }
  }

  void _openCommentPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailCommentPage(itemId: widget.itemId),
      ),
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
    return AnimatedBuilder(
      animation: Listenable.merge([appController, authService]),
      builder: (context, child) {
        final TradeItem? item = appController.itemById(widget.itemId);
        final user = authService.currentUser;
        if (item == null) {
          return const Scaffold(
            body: SafeArea(child: Center(child: Text('물건을 찾을 수 없습니다.'))),
          );
        }

        final bool isOwner = user?.id == item.ownerId;
        final bool hasPendingRequest =
            user != null &&
            appController.requests.any(
              (request) =>
                  request.itemId == item.id &&
                  request.requesterId == user.id &&
                  request.status == TradeRequestStatus.pending,
            );
        final bool canRequest =
            user != null && !isOwner && item.isActive && !hasPendingRequest;
        final String buttonText = isOwner
            ? '내가 등록한 물건'
            : !item.isActive
            ? '거래 완료'
            : hasPendingRequest
            ? '요청 완료'
            : '${item.tradeMethod.label} 요청';

        return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: ItemDetailBottomBar(
            buttonText: buttonText,
            isLiked: user != null && item.isLikedBy(user.id),
            isRequestEnabled: canRequest,
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
                        ItemDetailImageArea(item: item),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 28),
                              ItemDetailInfoSection(item: item),
                              ItemDetailWriterSection(item: item),
                              ItemDetailCommentPreview(
                                comments: appController.commentsFor(item.id),
                                onMoreTap: _openCommentPage,
                              ),
                              ItemDetailWantedSection(item: item),
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
      },
    );
  }
}
