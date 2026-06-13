import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AdminNoticeDetailContent extends StatelessWidget {
  const AdminNoticeDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('서비스 점검 안내', style: AppTextStyles.adminNoticeDetailTitle),
        const SizedBox(height: 28),

        const Text(
          '작성자 관리자 | 2026.05.18 14:00',
          style: AppTextStyles.adminNoticeDetailInfo,
        ),
        const SizedBox(height: 34),

        Container(height: 1, color: AppColors.borderGray),
        const SizedBox(height: 34),

        const Text('''안녕하세요, 아나바다 운영팀입니다.

보다 안정적인 서비스 제공을 위해 아래와 같이 시스템 점검을 진행할 예정입니다.

점검 일시
2024년 5월 21일 02:00 ~ 06:00

점검 내용
서비스 안정화 작업
데이터베이스 최적화
시스템 성능 개선

점검 시간 동안 서비스 이용이 일시적으로 제한될 수 있습니다.
이용에 불편을 드려 죄송합니다.''', style: AppTextStyles.adminNoticeDetailContent),
      ],
    );
  }
}
