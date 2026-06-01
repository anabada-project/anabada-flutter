import 'package:flutter/material.dart';

import '../widgets/admin_notice_content_field.dart';
import '../widgets/admin_notice_title_field.dart';
import '../widgets/admin_notice_write_button.dart';
import '../widgets/admin_notice_write_header.dart';

class AdminNoticeWritePage extends StatelessWidget {
  const AdminNoticeWritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              SizedBox(height: 28),

              AdminNoticeWriteHeader(),

              SizedBox(height: 48),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      AdminNoticeTitleField(
                        label: '제목',
                        hintText: '제목을 입력해 주세요.',
                      ),

                      SizedBox(height: 32),

                      AdminNoticeTitleField(
                        label: '작성자',
                        hintText: '관리자',
                        readOnly: true,
                      ),

                      SizedBox(height: 32),

                      AdminNoticeTitleField(
                        label: '날짜',
                        hintText: '날짜를 입력해 주세요.',
                      ),

                      SizedBox(height: 32),

                      AdminNoticeContentField(),

                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: AdminNoticeWriteButton(),
    );
  }
}
