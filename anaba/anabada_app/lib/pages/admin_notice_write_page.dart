import 'package:flutter/material.dart';

import '../widgets/admin_notice_content_field.dart';
import '../widgets/admin_notice_input_field.dart';
import '../widgets/admin_notice_write_button.dart';
import '../widgets/admin_notice_write_header.dart';

class AdminNoticeWritePage extends StatelessWidget {
  const AdminNoticeWritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: const SafeArea(
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
                      AdminNoticeInputField(
                        label: '제목',
                        hintText: '제목을 입력해 주세요.',
                      ),

                      SizedBox(height: 32),

                      AdminNoticeInputField(
                        label: '작성자',
                        hintText: '관리자',
                        readOnly: true,
                      ),

                      SizedBox(height: 32),

                      AdminNoticeInputField(
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

      bottomNavigationBar: AdminNoticeWriteButton(
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
    );
  }
}
