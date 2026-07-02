import 'package:flutter/material.dart';

import 'item_register_colors.dart';

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
