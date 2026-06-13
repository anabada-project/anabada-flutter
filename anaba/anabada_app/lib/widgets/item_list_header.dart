import 'package:flutter/material.dart';

class ItemListHeader extends StatelessWidget {
  const ItemListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 56,
      child: Center(
        child: Text(
          '물건 조회',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
