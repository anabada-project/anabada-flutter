import 'package:flutter/material.dart';

import '../widgets/item_detail_comment_empty_state.dart';
import '../widgets/item_detail_comment_header.dart';
import '../widgets/item_detail_comment_input_bar.dart';
import '../widgets/item_detail_comment_section_title.dart';
import '../widgets/item_detail_comment_target_card.dart';
import '../widgets/item_detail_comment_tile.dart';

class ItemDetailCommentPage extends StatelessWidget {
  const ItemDetailCommentPage({super.key});

  // 댓글 없는 화면 확인하려면 true
  // 댓글 있는 화면 확인하려면 false
  static const bool _showEmptyStatePreview = false;

  static const List<_CommentData> _dummyComments = [
    _CommentData(
      name: '김준수',
      content: 'ㅎㅇ',
      time: '2시간 전',
      isWriter: false,
      canManage: false,
    ),
    _CommentData(
      name: '안율',
      content: 'ㅎㅇ',
      time: '2시간 전',
      isWriter: false,
      canManage: false,
    ),
    _CommentData(
      name: '추혜인',
      content: 'ㅎㅇ',
      time: '2시간 전',
      isWriter: true,
      canManage: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<_CommentData> comments = _showEmptyStatePreview
        ? const []
        : _dummyComments;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const ItemDetailCommentInputBar(),
      body: SafeArea(
        child: Column(
          children: [
            const ItemDetailCommentHeader(),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: ItemDetailCommentTargetCard(),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ItemDetailCommentSectionTitle(count: comments.length),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: comments.isEmpty
                  ? const ItemDetailCommentEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      itemCount: comments.length,
                      separatorBuilder: (context, index) {
                        return const Column(
                          children: [
                            SizedBox(height: 22),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF0F0F0),
                            ),
                            SizedBox(height: 22),
                          ],
                        );
                      },
                      itemBuilder: (context, index) {
                        final comment = comments[index];

                        return ItemDetailCommentTile(
                          name: comment.name,
                          content: comment.content,
                          time: comment.time,
                          isWriter: comment.isWriter,
                          canManage: comment.canManage,
                          onEdit: () {},
                          onDelete: () {},
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentData {
  final String name;
  final String content;
  final String time;
  final bool isWriter;
  final bool canManage;

  const _CommentData({
    required this.name,
    required this.content,
    required this.time,
    required this.isWriter,
    required this.canManage,
  });
}
