import 'package:flutter/material.dart';

import '../widgets/admin_notice_edit_button.dart';
import '../widgets/admin_notice_edit_content_field.dart';
import '../widgets/admin_notice_edit_header.dart';
import '../widgets/admin_notice_edit_input_field.dart';

class AdminNoticeEditPage extends StatefulWidget {
  const AdminNoticeEditPage({super.key});

  @override
  State<AdminNoticeEditPage> createState() => _AdminNoticeEditPageState();
}

class _AdminNoticeEditPageState extends State<AdminNoticeEditPage> {
  final TextEditingController _titleController = TextEditingController(
    text: '서비스 점검 안내',
  );

  final TextEditingController _writerController = TextEditingController(
    text: '관리자',
  );

  final TextEditingController _dateController = TextEditingController(
    text: '2026.05.18',
  );

  final TextEditingController _contentController = TextEditingController(
    text: '''안녕하세요, 아나바다 운영팀입니다.

보다 안정적인 서비스 제공을 위해 아래와 같이 시스템 점검을 진행할 예정입니다.

점검 일시
2024년 5월 21일 02:00 ~ 06:00

점검 내용
서비스 안정화 작업
데이터베이스 최적화
시스템 성능 개선

점검 시간 동안 서비스 이용이 일시적으로 제한될 수 있습니다.
이용에 불편을 드려 죄송합니다.''',
  );

  @override
  void dispose() {
    _titleController.dispose();
    _writerController.dispose();
    _dateController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNotice() {
    // UI 단계라 실제 저장 기능은 나중에 연결
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const AdminNoticeEditHeader(),
              const SizedBox(height: 44),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AdminNoticeEditInputField(
                        label: '제목',
                        controller: _titleController,
                      ),
                      const SizedBox(height: 36),
                      AdminNoticeEditInputField(
                        label: '작성자',
                        controller: _writerController,
                        enabled: false,
                      ),
                      const SizedBox(height: 36),
                      AdminNoticeEditInputField(
                        label: '날짜',
                        controller: _dateController,
                      ),
                      const SizedBox(height: 36),
                      AdminNoticeEditContentField(
                        controller: _contentController,
                      ),
                      const SizedBox(height: 36),
                      AdminNoticeEditButton(onPressed: _saveNotice),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
