import 'package:flutter/material.dart';

class ItemDetailHeader extends StatelessWidget {
  const ItemDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            '물건 상세',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Positioned(
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.maybePop(context);
              },
              behavior: HitTestBehavior.opaque,
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
