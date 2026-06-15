import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../controllers/app_controller.dart';
import '../pages/admin_notice_edit_page.dart';

class AdminNoticeDetailBottomButton extends StatelessWidget {
  const AdminNoticeDetailBottomButton({
    super.key,
    required this.noticeId,
  });

  final String noticeId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () async {
                    final saved = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminNoticeEditPage(noticeId: noticeId),
                      ),
                    );
                    if (!context.mounted || saved != true) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('공지가 수정되었습니다.')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.borderGray),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '수정하기',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text('공지 삭제'),
                          content: const Text('이 공지를 삭제하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext, false);
                              },
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext, true);
                              },
                              child: const Text(
                                '삭제',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    if (!context.mounted || shouldDelete != true) {
                      return;
                    }
                    final messenger = ScaffoldMessenger.of(context);
                    await appController.deleteNotice(noticeId);
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.pop(context);
                    messenger.showSnackBar(
                      const SnackBar(content: Text('공지가 삭제되었습니다.')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '삭제하기',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              '목록으로',
              style: AppTextStyles.adminNoticeDetailButton,
            ),
          ),
        ),
      ],
    );
  }
}
