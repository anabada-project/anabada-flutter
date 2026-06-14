import 'package:flutter/material.dart';

class ItemDetailCommentPreview extends StatelessWidget {
  final VoidCallback onMoreTap;

  const ItemDetailCommentPreview({super.key, required this.onMoreTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 22),
        _CommentHeader(onMoreTap: onMoreTap),
        const SizedBox(height: 16),
        const _CommentTile(name: '김준수', content: '어디신가요', time: '2시간 전'),
        const SizedBox(height: 14),
        const _CommentTile(name: '안율', content: '방가방가', time: '2시간 전'),
        const SizedBox(height: 22),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
      ],
    );
  }
}

class _CommentHeader extends StatelessWidget {
  final VoidCallback onMoreTap;

  const _CommentHeader({required this.onMoreTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '댓글 3',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: onMoreTap,
          behavior: HitTestBehavior.opaque,
          child: const Row(
            children: [
              Text(
                '더보기',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 20, color: Colors.black),
            ],
          ),
        ),
      ],
    );
  }
}

class _CommentTile extends StatelessWidget {
  final String name;
  final String content;
  final String time;

  const _CommentTile({
    required this.name,
    required this.content,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _CommentProfileIcon(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          time,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}

class _CommentProfileIcon extends StatelessWidget {
  const _CommentProfileIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: Color(0xFFE0E0E0),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, size: 28, color: Colors.white),
    );
  }
}
