import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';

class MainNoticeBox extends StatelessWidget {
  const MainNoticeBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEAEAEA)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NoticeRow(title: '공지 제목', time: '3시간 전'),
          NoticeRow(title: '공지 제목', time: '1일 전'),
          NoticeRow(title: '공지 제목', time: '2일 전'),
        ],
      ),
    );
  }
}

class NoticeRow extends StatelessWidget {
  const NoticeRow({super.key, required this.title, required this.time});

  final String title;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('•', style: AppTextStyles.noticeDot),
        const SizedBox(width: 10),
        Text(title, style: AppTextStyles.noticeTitle),
        const Spacer(),
        Text(time, style: AppTextStyles.noticeTime),
      ],
    );
  }
}
