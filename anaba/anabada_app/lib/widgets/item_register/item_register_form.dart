import 'package:flutter/material.dart';

import 'item_register_colors.dart';

class ItemRegisterLabel extends StatelessWidget {
  const ItemRegisterLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: ItemRegisterColors.textColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class ItemRegisterTextField extends StatelessWidget {
  const ItemRegisterTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final TextField textField = TextField(
      controller: controller,
      maxLines: maxLines,
      minLines: maxLines > 1 ? maxLines : 1,
      keyboardType:
          keyboardType ??
          (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
      textInputAction: maxLines > 1
          ? TextInputAction.newline
          : TextInputAction.done,
      cursorColor: ItemRegisterColors.mainColor,
      style: const TextStyle(
        color: ItemRegisterColors.textColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: ItemRegisterColors.hintColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 11,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: ItemRegisterColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: ItemRegisterColors.mainColor),
        ),
      ),
    );

    if (maxLines == 1) {
      return SizedBox(height: 42, child: textField);
    }
    return textField;
  }
}

class ItemRegisterSelectButton extends StatelessWidget {
  const ItemRegisterSelectButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? ItemRegisterColors.mainColor : Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: isSelected
                ? ItemRegisterColors.mainColor
                : ItemRegisterColors.borderColor,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : ItemRegisterColors.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class ItemRegisterErrorText extends StatelessWidget {
  const ItemRegisterErrorText({super.key, required this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    if (text == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text!,
        style: const TextStyle(
          color: ItemRegisterColors.errorColor,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
