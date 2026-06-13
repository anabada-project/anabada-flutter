import 'package:flutter/material.dart';

class ItemDetailWriterSection extends StatelessWidget {
  const ItemDetailWriterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 22),
        Row(
          children: [
            _ProfileIcon(size: 48),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '추혜인',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '10기',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 22),
        Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
      ],
    );
  }
}

class _ProfileIcon extends StatelessWidget {
  final double size;

  const _ProfileIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFE0E0E0),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, size: size * 0.65, color: Colors.white),
    );
  }
}
