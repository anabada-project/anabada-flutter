import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../services/auth_service.dart';
import '../widgets/admin_notice_content_field.dart';
import '../widgets/admin_notice_input_field.dart';
import '../widgets/admin_notice_write_button.dart';
import '../widgets/admin_notice_write_header.dart';

class AdminNoticeWritePage extends StatefulWidget {
  const AdminNoticeWritePage({super.key});

  @override
  State<AdminNoticeWritePage> createState() => _AdminNoticeWritePageState();
}

class _AdminNoticeWritePageState extends State<AdminNoticeWritePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _writerController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _writerController.text = authService.currentUser?.name ?? '관리자';
    _dateController.text =
        '${now.year}.${now.month.toString().padLeft(2, '0')}.'
        '${now.day.toString().padLeft(2, '0')}';
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
    await appController.createNotice(
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
              const SizedBox(height: 28),
              const AdminNoticeWriteHeader(),
              const SizedBox(height: 48),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      AdminNoticeInputField(
                        label: '제목',
                        hintText: '제목을 입력해 주세요.',
                        controller: _titleController,
                      ),
                      const SizedBox(height: 32),
                      AdminNoticeInputField(
                        label: '작성자',
                        hintText: '관리자',
                        controller: _writerController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 32),
                      AdminNoticeInputField(
                        label: '날짜',
                        hintText: '날짜를 입력해 주세요.',
                        controller: _dateController,
                      ),
                      const SizedBox(height: 32),
                      AdminNoticeContentField(controller: _contentController),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AdminNoticeWriteButton(
        onPressed: _isSaving ? null : _saveNotice,
      ),
    );
  }
}
