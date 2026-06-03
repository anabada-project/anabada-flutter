import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // 페이지 큰 제목: 마이페이지
  static const TextStyle pageTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // 정보 수정 페이지 상단 제목
  static const TextStyle editPageTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // 프로필 이름
  static const TextStyle profileName = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // 섹션 제목
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // 수정 페이지 라벨
  static const TextStyle editLabel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // 회색 일반 텍스트
  static const TextStyle grayBody = TextStyle(
    fontSize: 15,
    color: AppColors.grayText,
  );

  // 정보 수정 버튼
  static const TextStyle editButton = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: AppColors.mainColor,
  );

  // 노란 버튼 안 흰색 텍스트
  static const TextStyle whiteButton = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // 더보기 텍스트
  static const TextStyle moreText = TextStyle(
    fontSize: 15,
    color: AppColors.grayText,
  );

  // 입력창 힌트 텍스트
  static const TextStyle hintText = TextStyle(
    fontSize: 15,
    color: AppColors.grayText,
  );

  // 관리자 공지 작성 상단 제목
  static const TextStyle adminNoticeWriteHeaderTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // 관리자 공지 작성 라벨
  static const TextStyle adminNoticeWriteLabel = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // 관리자 공지 작성 힌트
  static const TextStyle adminNoticeWriteHint = TextStyle(
    fontSize: 15,
    color: AppColors.grayText,
  );

  // 관리자 공지 작성 버튼
  static const TextStyle adminNoticeWriteButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.disabledText,
  );

  // 관리자 공지 상세 상단 제목
  static const TextStyle adminNoticeDetailHeaderTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // 관리자 공지 상세 제목
  static const TextStyle adminNoticeDetailTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // 관리자 공지 상세 작성자/날짜
  static const TextStyle adminNoticeDetailInfo = TextStyle(
    fontSize: 12,
    color: AppColors.grayText,
  );

  // 관리자 공지 상세 본문
  static const TextStyle adminNoticeDetailContent = TextStyle(
    fontSize: 13,
    height: 1.45,
    color: Colors.black,
  );

  // 관리자 공지 상세 버튼
  static const TextStyle adminNoticeDetailButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // 알림 페이지 상단 제목
  static const TextStyle notificationHeaderTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // 알림 필터 탭
  static const TextStyle notificationTab = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.grayText,
  );

  // 선택된 알림 필터 탭
  static const TextStyle selectedNotificationTab = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // 알림 섹션 제목
  static const TextStyle notificationSectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // 알림 제목
  static const TextStyle notificationItemTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // 알림 내용
  static const TextStyle notificationItemContent = TextStyle(
    fontSize: 14,
    color: AppColors.grayText,
  );

  // 알림 시간
  static const TextStyle notificationTime = TextStyle(
    fontSize: 14,
    color: AppColors.grayText,
  );
}
