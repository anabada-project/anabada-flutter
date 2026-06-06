import 'package:flutter/material.dart';

class ItemDetailBottomBar extends StatelessWidget {
  final String buttonText;
  final bool isLiked;
  final VoidCallback onRequestTap;
  final VoidCallback onLikeTap;

  const ItemDetailBottomBar({
    super.key,
    required this.buttonText,
    required this.isLiked,
    required this.onRequestTap,
    required this.onLikeTap,
  });

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
                height: 43,
                child: ElevatedButton(
                  onPressed: onRequestTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: onLikeTap,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 36,
                height: 43,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 30,
                  color: isLiked ? const Color(0xFFFF4444) : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
