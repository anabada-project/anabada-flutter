import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class NoticeDetailContent extends StatelessWidget {
  const NoticeDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('서비스 점검 안내', style: AppTextStyles.noticeDetailTitle),

        SizedBox(height: 22),

        Text(
          '작성자 관리자 | 2026.05.18 14:00',
          style: AppTextStyles.noticeDetailInfo,
        ),

        SizedBox(height: 34),

        Divider(height: 1, thickness: 1, color: AppColors.borderGray),

        SizedBox(height: 40),

        Text('''안녕하세요, 아나바다 운영팀입니다.

보다 안정적인 서비스 제공을 위해 아래와 같이 시스템 점검을 진행할 예정입니다.

점검 일시
2024년 5월 21일 02:00 ~ 06:00

점검 내용
서비스 안정화 작업
데이터베이스 최적화
시스템 성능 개선

점검 시간 동안 서비스 이용이 일시적으로 제한될 수 있습니다.
이용에 불편을 드려 죄송합니다.''', style: AppTextStyles.noticeDetailBody),
      ],
    );
  }
}
