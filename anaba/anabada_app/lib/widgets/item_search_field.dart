import 'package:flutter/material.dart';

class ItemSearchField extends StatelessWidget {
  final String? initialText;

  const ItemSearchField({super.key, this.initialText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: TextFormField(
        initialValue: initialText,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF4F4F4),
          hintText: '물건 제목, 키워드로 검색',
          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFBDBDBD)),
          suffixIcon: const Icon(
            Icons.search,
            size: 22,
            color: Color(0xFF9E9E9E),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
