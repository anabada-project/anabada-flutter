import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../widgets/admin_notice_edit_button.dart';
import '../widgets/admin_notice_edit_content_field.dart';
import '../widgets/admin_notice_edit_header.dart';
import '../widgets/admin_notice_edit_input_field.dart';

class AdminNoticeEditPage extends StatefulWidget {
  const AdminNoticeEditPage({super.key, required this.noticeId});

  final String noticeId;

  @override
  State<AdminNoticeEditPage> createState() => _AdminNoticeEditPageState();
}

class _AdminNoticeEditPageState extends State<AdminNoticeEditPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _writerController;
  late final TextEditingController _dateController;
  late final TextEditingController _contentController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final notice = appController.noticeById(widget.noticeId);
    final DateTime createdAt = notice?.createdAt ?? DateTime.now();
    _titleController = TextEditingController(text: notice?.title ?? '');
    _writerController = TextEditingController(text: notice?.author ?? '관리자');
    _dateController = TextEditingController(
      text:
          '${createdAt.year}.${createdAt.month.toString().padLeft(2, '0')}.'
          '${createdAt.day.toString().padLeft(2, '0')}',
    );
    _contentController = TextEditingController(text: notice?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _writerController.dispose();
    _dateController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNotice() async {
    final String title = _titleController.text.trim();
    final String content = _contentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 내용을 입력해주세요.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    await appController.updateNotice(
      noticeId: widget.noticeId,
      title: title,
      content: content,
      author: _writerController.text.trim(),
      createdAt: _parseDate(_dateController.text),
    );
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  DateTime _parseDate(String value) {
    final List<int> parts = value
        .split('.')
        .map((part) => int.tryParse(part.trim()))
        .whereType<int>()
        .toList();
    if (parts.length == 3) {
      return DateTime(parts[0], parts[1], parts[2]);
    }
    return DateTime.now();
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
                      AdminNoticeEditButton(
                        onPressed: _isSaving ? null : _saveNotice,
                      ),
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
