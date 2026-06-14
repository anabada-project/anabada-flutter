import 'package:flutter/material.dart';

import '../widgets/item_detail_comment_empty_state.dart';
import '../widgets/item_detail_comment_header.dart';
import '../widgets/item_detail_comment_input_bar.dart';
import '../widgets/item_detail_comment_section_title.dart';
import '../widgets/item_detail_comment_target_card.dart';
import '../widgets/item_detail_comment_tile.dart';

class ItemDetailCommentPage extends StatefulWidget {
  const ItemDetailCommentPage({super.key});

  @override
  State<ItemDetailCommentPage> createState() => _ItemDetailCommentPageState();
}

class _ItemDetailCommentPageState extends State<ItemDetailCommentPage> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  final List<_CommentData> _comments = [
    const _CommentData(
      id: 1,
      author: '김준수',
      content: 'ㅎㅇ',
      time: '2시간 전',
      isWriter: false,
      canManage: true,
    ),
    const _CommentData(
      id: 2,
      author: '안율',
      content: 'ㅎㅇ',
      time: '2시간 전',
      isWriter: false,
      canManage: true,
    ),
    const _CommentData(
      id: 3,
      author: '추혜인',
      content: 'ㅎㅇ',
      time: '2시간 전',
      isWriter: true,
      canManage: true,
    ),
  ];

  int? _editingCommentId;

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();

    super.dispose();
  }

  void _submitComment() {
    final String content = _commentController.text.trim();

    if (content.isEmpty) {
      return;
    }

    if (_editingCommentId != null) {
      _updateComment(content);
      return;
    }

    _addComment(content);
  }

  void _addComment(String content) {
    final int newId = DateTime.now().millisecondsSinceEpoch;

    setState(() {
      _comments.add(
        _CommentData(
          id: newId,
          author: '추혜인',
          content: content,
          time: '방금 전',
          isWriter: true,
          canManage: true,
        ),
      );
    });

    _commentController.clear();
    _commentFocusNode.unfocus();
  }

  void _updateComment(String content) {
    final int editingId = _editingCommentId!;

    setState(() {
      final int index = _comments.indexWhere(
        (comment) => comment.id == editingId,
      );

      if (index == -1) {
        return;
      }

      final _CommentData oldComment = _comments[index];

      _comments[index] = oldComment.copyWith(content: content, time: '방금 전');

      _editingCommentId = null;
    });

    _commentController.clear();
    _commentFocusNode.unfocus();
  }

  void _startEditComment(_CommentData comment) {
    setState(() {
      _editingCommentId = comment.id;
      _commentController.text = comment.content;
      _commentController.selection = TextSelection.fromPosition(
        TextPosition(offset: _commentController.text.length),
      );
    });

    _commentFocusNode.requestFocus();
  }

  void _deleteComment(int commentId) {
    setState(() {
      _comments.removeWhere((comment) => comment.id == commentId);

      if (_editingCommentId == commentId) {
        _editingCommentId = null;
        _commentController.clear();
      }
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingCommentId = null;
      _commentController.clear();
    });

    _commentFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = _editingCommentId != null;

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
                  const ItemDetailCommentTargetCard(),
                  const SizedBox(height: 28),
                  ItemDetailCommentSectionTitle(count: _comments.length),
                  const SizedBox(height: 18),

                  if (_comments.isEmpty)
                    const ItemDetailCommentEmptyState()
                  else
                    ..._comments.map((comment) {
                      return ItemDetailCommentTile(
                        author: comment.author,
                        content: comment.content,
                        time: comment.time,
                        isWriter: comment.isWriter,
                        canManage: comment.canManage,
                        onEdit: () {
                          _startEditComment(comment);
                        },
                        onDelete: () {
                          _deleteComment(comment.id);
                        },
                      );
                    }),
                ],
              ),
            ),
            ItemDetailCommentInputBar(
              controller: _commentController,
              focusNode: _commentFocusNode,
              isEditing: isEditing,
              onCancelEdit: _cancelEdit,
              onSubmit: _submitComment,
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentData {
  final int id;
  final String author;
  final String content;
  final String time;
  final bool isWriter;
  final bool canManage;

  const _CommentData({
    required this.id,
    required this.author,
    required this.content,
    required this.time,
    required this.isWriter,
    required this.canManage,
  });

  _CommentData copyWith({String? content, String? time}) {
    return _CommentData(
      id: id,
      author: author,
      content: content ?? this.content,
      time: time ?? this.time,
      isWriter: isWriter,
      canManage: canManage,
    );
  }
}
