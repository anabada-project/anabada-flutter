import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle notificationHeaderTitle = TextStyle(
    fontSize: 16,
  static const TextStyle noticeDetailHeaderTitle = TextStyle(
  // 페이지 큰 제목: 마이페이지
  static const TextStyle pageTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle notificationSelectedTab = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle notificationTab = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: AppColors.grayText,
  );

  static const TextStyle notificationSectionTitle = TextStyle(
    fontSize: 16,
  // 정보 수정 페이지 상단 제목
  static const TextStyle editPageTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle noticeDetailTitle = TextStyle(
    fontSize: 22,
  // 프로필 이름
  static const TextStyle profileName = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle noticeDetailInfo = TextStyle(
    fontSize: 14,
    color: AppColors.grayText,
  );

  static const TextStyle noticeDetailBody = TextStyle(
    fontSize: 16,
    height: 1.45,
    color: Colors.black,
  );

  static const TextStyle noticeDetailButton = TextStyle(
  // 섹션 제목: 내가 등록한 물건, 최근 조회한 물건
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle notificationItemTitle = TextStyle(
  // 수정 페이지 라벨: 이름, 이메일, 전공, 기수
  static const TextStyle editLabel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle notificationItemContent = TextStyle(
    fontSize: 13,
    color: AppColors.grayText,
  );

  static const TextStyle notificationTime = TextStyle(
    fontSize: 13,
  // 회색 일반 텍스트: 이메일, 전공, 기수
  static const TextStyle grayBody = TextStyle(
    fontSize: 15,
    color: AppColors.grayText,
  );

  // 정보 수정 버튼 / 선택 안 된 기수 버튼
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
}
