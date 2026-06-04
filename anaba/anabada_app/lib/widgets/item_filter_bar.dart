import 'package:flutter/material.dart';

class ItemFilterBar extends StatelessWidget {
  final String selectedSort;
  final String selectedCategory;
  final VoidCallback onSortTap;
  final VoidCallback onCategoryTap;

  const ItemFilterBar({
    super.key,
    required this.selectedSort,
    required this.selectedCategory,
    required this.onSortTap,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ItemFilterButton(title: selectedSort, onTap: onSortTap),
        _ItemFilterButton(title: selectedCategory, onTap: onCategoryTap),
      ],
    );
  }
}

class _ItemFilterButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _ItemFilterButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.keyboard_arrow_down, size: 17, color: Colors.black),
        ],
      ),
    );
  }
}
