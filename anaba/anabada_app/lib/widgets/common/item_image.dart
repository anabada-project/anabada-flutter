import 'dart:typed_data';

import 'package:flutter/material.dart';

class ItemImage extends StatelessWidget {
  const ItemImage({
    super.key,
    this.imageBytes,
    this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.backgroundColor = const Color(0xFFF0F1F3),
  });

  final Uint8List? imageBytes;
  final String? imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (imageBytes != null) {
      child = Image.memory(
        imageBytes!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      child = Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    } else {
      child = _placeholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(width: width, height: height, child: child),
    );
  }

  Widget _placeholder() {
    return ColoredBox(
      color: backgroundColor,
      child: const Center(
        child: Icon(Icons.image_outlined, color: Color(0xFFBDBDBD)),
      ),
    );
  }
}
