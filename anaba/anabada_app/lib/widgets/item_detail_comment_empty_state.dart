import 'package:flutter/material.dart';

class ItemDetailCommentEmptyState extends StatelessWidget {
  const ItemDetailCommentEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 360,
      child: Center(
        child: Text(
          '아직 댓글이 없어요.\n첫 댓글을 남겨보세요.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: Color(0xFF9E9E9E),
          ),
        ),
      ),
    );
  }
}
