import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../models/item_comment.dart';
import '../models/trade_item.dart';
import '../services/auth_service.dart';
import '../utils/time_formatter.dart';
import '../widgets/item_detail_comment_empty_state.dart';
import '../widgets/item_detail_comment_header.dart';
import '../widgets/item_detail_comment_input_bar.dart';
import '../widgets/item_detail_comment_section_title.dart';
import '../widgets/item_detail_comment_target_card.dart';
import '../widgets/item_detail_comment_tile.dart';

class ItemDetailCommentPage extends StatefulWidget {
  const ItemDetailCommentPage({super.key, required this.itemId});

  final String itemId;

  @override
  State<ItemDetailCommentPage> createState() => _ItemDetailCommentPageState();
}

class _ItemDetailCommentPageState extends State<ItemDetailCommentPage> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  String? _editingCommentId;
  String? _replyingToCommentId;

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final String content = _commentController.text.trim();
    final user = authService.currentUser;
    if (content.isEmpty || user == null) return;

    try {
      if (_editingCommentId != null) {
        await appController.updateComment(
          commentId: _editingCommentId!,
          authorId: user.id,
          content: content,
        );
      } else {
        await appController.createComment(
          itemId: widget.itemId,
          authorId: user.id,
          authorName: user.name,
          content: content,
          parentCommentId: _replyingToCommentId,
        );
      }

      _cancelInputMode();
    } on StateError catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    }
  }

  void _startEditComment(ItemComment comment) {
    setState(() {
      _replyingToCommentId = null;
      _editingCommentId = comment.id;
      _commentController.text = comment.content;
      _commentController.selection = TextSelection.collapsed(
        offset: comment.content.length,
      );
    });
    _commentFocusNode.requestFocus();
  }

  void _startReply(ItemComment comment) {
    setState(() {
      _editingCommentId = null;
      _replyingToCommentId = comment.id;
      _commentController.clear();
    });
    _commentFocusNode.requestFocus();
  }

  Future<void> _deleteComment(String commentId) async {
    final user = authService.currentUser;
    if (user == null) return;

    try {
      await appController.deleteComment(
        commentId: commentId,
        authorId: user.id,
      );
      if (_editingCommentId == commentId ||
          _replyingToCommentId == commentId) {
        _cancelInputMode();
      }
    } on StateError catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    }
  }

  void _cancelInputMode() {
    setState(() {
      _editingCommentId = null;
      _replyingToCommentId = null;
      _commentController.clear();
    });
    _commentFocusNode.unfocus();
  }

  List<ItemComment> _orderedComments(List<ItemComment> comments) {
    final List<ItemComment> ordered = [];
    final List<ItemComment> roots = comments
        .where((comment) => comment.parentCommentId == null)
        .toList();
    for (final ItemComment root in roots) {
      ordered.add(root);
      ordered.addAll(
        comments.where((comment) => comment.parentCommentId == root.id),
      );
    }
    return ordered;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([appController, authService]),
      builder: (context, child) {
        final TradeItem? item = appController.itemById(widget.itemId);
        final user = authService.currentUser;
        if (item == null) {
          return const Scaffold(body: Center(child: Text('물건을 찾을 수 없습니다.')));
        }

        final List<ItemComment> comments = appController.commentsFor(item.id);
        final List<ItemComment> orderedComments = _orderedComments(comments);

        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(
              children: [
                const ItemDetailCommentHeader(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    children: [
                      const SizedBox(height: 18),
                      ItemDetailCommentTargetCard(
                        item: item,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 28),
                      ItemDetailCommentSectionTitle(count: comments.length),
                      const SizedBox(height: 18),
                      if (orderedComments.isEmpty)
                        const ItemDetailCommentEmptyState()
                      else
                        ...orderedComments.map((comment) {
                          final ItemComment? parent =
                              comment.parentCommentId == null
                              ? null
                              : appController.commentById(
                                  comment.parentCommentId!,
                                );
                          return Padding(
                            padding: EdgeInsets.only(
                              left: comment.parentCommentId == null ? 0 : 32,
                            ),
                            child: ItemDetailCommentTile(
                              author: comment.authorName,
                              content: comment.content,
                              time: formatRelativeTime(comment.createdAt),
                              isWriter: comment.authorId == item.ownerId,
                              canManage: user?.id == comment.authorId,
                              replyToName: parent?.authorName,
                              onReply: () => _startReply(comment),
                              onEdit: () => _startEditComment(comment),
                              onDelete: () => _deleteComment(comment.id),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
                ItemDetailCommentInputBar(
                  controller: _commentController,
                  focusNode: _commentFocusNode,
                  isEditing: _editingCommentId != null,
                  isReplying: _replyingToCommentId != null,
                  onCancelEdit: _cancelInputMode,
                  onSubmit: _submitComment,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
