import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../pages/admin_notice_write_page.dart';

class AdminNoticeHeader extends StatelessWidget {
  const AdminNoticeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          ),

          const Expanded(
            child: Center(
              child: Text('공지사항', style: AppTextStyles.adminNoticeHeaderTitle),
            ),
          ),

          SizedBox(
            height: 28,
            child: ElevatedButton(
              onPressed: () async {
                final created = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminNoticeWritePage(),
                  ),
                );
                if (!context.mounted || created != true) {
                  return;
                }
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('공지가 등록되었습니다.')));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                '+ 추가',
                style: AppTextStyles.adminNoticeAddButton,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
