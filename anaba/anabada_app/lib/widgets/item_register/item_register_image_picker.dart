import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'item_register_colors.dart';
import 'item_register_form.dart';

class ItemImagePickerBox extends StatelessWidget {
  const ItemImagePickerBox({
    super.key,
    required this.imageBytes,
    required this.errorText,
    required this.onTap,
  });

  final Uint8List? imageBytes;
  final String? errorText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: ItemRegisterColors.imageBoxBackgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ItemRegisterColors.borderColor),
            ),
            child: imageBytes == null
                ? const _EmptyImagePickerContent()
                : _SelectedImagePreview(imageBytes: imageBytes!),
          ),
        ),
        ItemRegisterErrorText(text: errorText),
      ],
    );
  }
}

class _EmptyImagePickerContent extends StatelessWidget {
  const _EmptyImagePickerContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.image_outlined, size: 28, color: Color(0xFFBDBDBD)),
        const SizedBox(height: 12),
        const Text(
          '사진을 추가해주세요.',
          style: TextStyle(
            color: ItemRegisterColors.hintColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: 100,
          height: 33,
          decoration: BoxDecoration(
            color: ItemRegisterColors.mainColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 18, color: Colors.white),
              SizedBox(width: 5),
              Text(
                '사진 추가',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectedImagePreview extends StatelessWidget {
  const _SelectedImagePreview({required this.imageBytes});

  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.memory(
        imageBytes,
        width: double.infinity,
        height: 150,
        fit: BoxFit.cover,
      ),
    );
  }
}
