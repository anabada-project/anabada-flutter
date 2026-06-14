import 'package:flutter/material.dart';

class ItemDetailCommentInputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isEditing;
  final VoidCallback onCancelEdit;
  final VoidCallback onSubmit;

  const ItemDetailCommentInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isEditing,
    required this.onCancelEdit,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(32, 12, 32, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isEditing) ...[
              Row(
                children: [
                  const Text(
                    '댓글 수정 중',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onCancelEdit,
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFF4B4B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        if (controller.text.trim().isNotEmpty) {
                          onSubmit();
                        }
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
                          borderSide: const BorderSide(
                            color: Color(0xFFDADADA),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFFFB800),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    final bool isTextEmpty = value.text.trim().isEmpty;

                    return SizedBox(
                      width: 72,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: isTextEmpty ? null : onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isTextEmpty
                              ? const Color(0xFFE0E0E0)
                              : const Color(0xFFFFB800),
                          disabledBackgroundColor: const Color(0xFFE0E0E0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          isEditing ? '수정' : '등록',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isTextEmpty
                                ? const Color(0xFF9E9E9E)
                                : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
