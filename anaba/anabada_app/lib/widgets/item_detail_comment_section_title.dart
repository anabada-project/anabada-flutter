import 'package:flutter/material.dart';

class ItemDetailCommentSectionTitle extends StatelessWidget {
  final int count;

  const ItemDetailCommentSectionTitle({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Text(
      '댓글 $count',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }
}
