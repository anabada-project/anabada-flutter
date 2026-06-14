import 'package:flutter/material.dart';

class ItemDetailCommentHeader extends StatelessWidget {
  const ItemDetailCommentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            '댓글',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Positioned(
            left: 32,
            child: GestureDetector(
              onTap: () {
                Navigator.maybePop(context);
              },
              behavior: HitTestBehavior.opaque,
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
