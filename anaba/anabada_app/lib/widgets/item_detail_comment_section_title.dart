import 'package:flutter/material.dart';

class ItemDetailCommentSectionTitle extends StatelessWidget {
  final int count;

  const ItemDetailCommentSectionTitle({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '댓글 $count',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}
