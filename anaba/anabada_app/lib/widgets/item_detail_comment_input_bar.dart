import 'package:flutter/material.dart';

class ItemDetailCommentInputBar extends StatefulWidget {
  const ItemDetailCommentInputBar({super.key});

  @override
  State<ItemDetailCommentInputBar> createState() =>
      _ItemDetailCommentInputBarState();
}

class _ItemDetailCommentInputBarState extends State<ItemDetailCommentInputBar> {
  final TextEditingController _commentController = TextEditingController();
  String commentText = '';

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleCommentChanged(String value) {
    setState(() {
      commentText = value;
    });
  }

  void _handleSubmit() {
    final String trimmedComment = commentText.trim();

    if (trimmedComment.isEmpty) {
      return;
    }

    // 기능/API 연결 단계에서 댓글 등록 처리
    _commentController.clear();

    setState(() {
      commentText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(32, 12, 32, 10),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 46,
                child: TextField(
                  controller: _commentController,
                  onChanged: _handleCommentChanged,
                  onSubmitted: (_) {
                    _handleSubmit();
                  },
                  decoration: InputDecoration(
                    hintText: '댓글을 입력하세요.',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9E9E9E),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFFFB800)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 64,
              height: 46,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB800),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '등록',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
