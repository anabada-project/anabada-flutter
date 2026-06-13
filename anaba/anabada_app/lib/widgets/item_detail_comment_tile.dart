import 'package:flutter/material.dart';

class ItemDetailCommentTile extends StatelessWidget {
  final String name;
  final String content;
  final String time;
  final bool isWriter;
  final bool canManage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ItemDetailCommentTile({
    super.key,
    required this.name,
    required this.content,
    required this.time,
    required this.isWriter,
    required this.canManage,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _CommentProfileIcon(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  if (isWriter) ...[
                    const SizedBox(width: 8),
                    const _WriterBadge(),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                  const SizedBox(width: 18),
                  GestureDetector(
                    onTap: () {},
                    behavior: HitTestBehavior.opaque,
                    child: const Text(
                      '답글',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _CommentMoreButton(
          canManage: canManage,
          onEdit: onEdit,
          onDelete: onDelete,
        ),
      ],
    );
  }
}

class _CommentMoreButton extends StatelessWidget {
  final bool canManage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CommentMoreButton({
    required this.canManage,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (!canManage) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<String>(
      color: Colors.white,
      elevation: 6,
      offset: const Offset(-90, 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'edit') {
          onEdit();
        }

        if (value == 'delete') {
          onDelete();
        }
      },
      itemBuilder: (context) {
        return const [
          PopupMenuItem<String>(
            value: 'edit',
            height: 44,
            child: Text(
              '수정하기',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: 'delete',
            height: 44,
            child: Text(
              '삭제하기',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFF4444),
              ),
            ),
          ),
        ];
      },
      child: const SizedBox(
        width: 28,
        height: 28,
        child: Icon(Icons.more_horiz, size: 20, color: Colors.black),
      ),
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

class _WriterBadge extends StatelessWidget {
  const _WriterBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4C2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        '작성자',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFB800),
        ),
      ),
    );
  }
}
