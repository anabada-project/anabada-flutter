import 'package:flutter/material.dart';

class ItemDetailCommentTile extends StatelessWidget {
  final String author;
  final String content;
  final String time;
  final bool isWriter;
  final bool canManage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ItemDetailCommentTile({
    super.key,
    required this.author,
    required this.content,
    required this.time,
    required this.isWriter,
    required this.canManage,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 18),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Color(0xFFE4E4E4),
            child: Icon(Icons.person, size: 34, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      author,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    if (isWriter) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3C4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '작성자',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFFB800),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      '답글',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (canManage)
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                  return;
                }

                if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: 'edit',
                    height: 44,
                    child: Center(
                      child: Text(
                        '수정하기',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    height: 44,
                    child: Center(
                      child: Text(
                        '삭제하기',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFF4B4B),
                        ),
                      ),
                    ),
                  ),
                ];
              },
              child: const SizedBox(
                width: 32,
                height: 32,
                child: Icon(Icons.more_horiz, size: 22, color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}
