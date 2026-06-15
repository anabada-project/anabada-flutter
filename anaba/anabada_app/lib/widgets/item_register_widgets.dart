import 'dart:typed_data';

import 'package:flutter/material.dart';

class ItemRegisterColors {
  static const Color mainColor = Color(0xFFFFB800);
  static const Color textColor = Color(0xFF111111);
  static const Color hintColor = Color(0xFFA8A8A8);
  static const Color borderColor = Color(0xFFE5E5E5);
  static const Color errorColor = Color(0xFFFF4B4B);
  static const Color disabledButtonColor = Color(0xFFF1F2F4);
  static const Color imageBoxBackgroundColor = Color(0xFFFAFAFA);
}

class ItemRegisterAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ItemRegisterAppBar({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leadingWidth: 80,
      leading: Padding(
        padding: const EdgeInsets.only(left: 32),
        child: IconButton(
          onPressed: onBack,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      title: const Text(
        '물건 등록',
        style: TextStyle(
          color: ItemRegisterColors.textColor,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

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
    if (text == null) {
      return const SizedBox.shrink();
    }

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

class ItemRegisterSubmitButton extends StatelessWidget {
  const ItemRegisterSubmitButton({
    super.key,
    required this.isActive,
    required this.isLoading,
    required this.onTap,
  });

  final bool isActive;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 43,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive
              ? ItemRegisterColors.mainColor
              : ItemRegisterColors.disabledButtonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: isLoading
            ? const SizedBox(
                width: 19,
                height: 19,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                '등록하기',
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFFA8A8A8),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

class ItemRegisterBottomArea extends StatelessWidget {
  const ItemRegisterBottomArea({
    super.key,
    required this.isRegisterButtonActive,
    required this.isLoading,
    required this.currentIndex,
    required this.onRegisterTap,
    required this.onNavigationTap,
  });

  final bool isRegisterButtonActive;
  final bool isLoading;
  final int currentIndex;
  final VoidCallback onRegisterTap;
  final ValueChanged<int> onNavigationTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ItemRegisterSubmitButton(
                isActive: isRegisterButtonActive,
                isLoading: isLoading,
                onTap: onRegisterTap,
              ),
            ),
            const SizedBox(height: 18),
            ItemRegisterBottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onNavigationTap,
            ),
          ],
        ),
      ),
    );
  }
}

class ItemRegisterBottomNavigationBar extends StatelessWidget {
  const ItemRegisterBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: ItemRegisterColors.mainColor,
        unselectedItemColor: const Color(0xFFA8A8A8),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 24),
            label: '메인페이지',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 24),
            label: '물건 조회',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 25),
            label: '물건 등록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, size: 24),
            label: '찜',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}
