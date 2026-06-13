import 'package:flutter/material.dart';

import '../widgets/edit_profile_header.dart';
import '../widgets/edit_profile_input_field.dart';
import '../widgets/generation_button.dart';
import '../widgets/save_profile_button.dart';

class EditProfilePage extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialMajor;
  final String initialGeneration;

  const EditProfilePage({
    super.key,
    this.initialName = '추혜인',
    this.initialEmail = 's26000@gsm.hs.kr',
    this.initialMajor = '디자인',
    this.initialGeneration = '10기',
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _majorController;

  late String selectedGeneration;

  String? nameErrorText;
  String? majorErrorText;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _majorController = TextEditingController(text: widget.initialMajor);
    selectedGeneration = widget.initialGeneration;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _majorController.dispose();

    super.dispose();
  }

  void _selectGeneration(String generation) {
    setState(() {
      selectedGeneration = generation;
    });
  }

  void _clearNameError(String value) {
    if (nameErrorText == null) {
      return;
    }

    setState(() {
      nameErrorText = null;
    });
  }

  void _clearMajorError(String value) {
    if (majorErrorText == null) {
      return;
    }

    setState(() {
      majorErrorText = null;
    });
  }

  void _saveProfile() {
    final String name = _nameController.text.trim();
    final String major = _majorController.text.trim();

    setState(() {
      nameErrorText = name.isEmpty ? '이름을 입력해주세요.' : null;
      majorErrorText = major.isEmpty ? '전공을 입력해주세요.' : null;
    });

    if (name.isEmpty || major.isEmpty) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('프로필 정보가 저장되었습니다.')));

    // TODO: API 연결 단계에서 서버에 프로필 수정 요청 연결
  }

  void _handleResetPassword() {
    // TODO: 비밀번호 재설정 화면 이동 작업에서 구현
  }

  void _handleLogout() {
    // TODO: 로그아웃 기능/API 연결 작업에서 구현
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),

              const EditProfileHeader(),

              const SizedBox(height: 34),

              EditProfileInputField(
                label: '이름',
                hintText: '이름을 입력해주세요.',
                controller: _nameController,
                errorText: nameErrorText,
                onChanged: _clearNameError,
              ),

              const SizedBox(height: 30),

              EditProfileInputField(
                label: '이메일',
                hintText: 's26000@gsm.hs.kr',
                controller: _emailController,
                enabled: false,
              ),

              const SizedBox(height: 30),

              EditProfileInputField(
                label: '전공',
                hintText: '전공을 입력해주세요.',
                controller: _majorController,
                errorText: majorErrorText,
                onChanged: _clearMajorError,
              ),

              const SizedBox(height: 30),

              const Text(
                '기수',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: GenerationButton(
                      text: '8기',
                      selected: selectedGeneration == '8기',
                      onTap: () {
                        _selectGeneration('8기');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GenerationButton(
                      text: '9기',
                      selected: selectedGeneration == '9기',
                      onTap: () {
                        _selectGeneration('9기');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GenerationButton(
                      text: '10기',
                      selected: selectedGeneration == '10기',
                      onTap: () {
                        _selectGeneration('10기');
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 38),

              Container(
                width: double.infinity,
                height: 1,
                color: const Color(0xFFF0F0F0),
              ),

              const SizedBox(height: 22),

              const Text(
                '계정 보안',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 12),

              _AccountSecurityTile(
                text: '비밀번호 재설정',
                onTap: _handleResetPassword,
              ),

              const SizedBox(height: 8),

              _AccountSecurityTile(text: '로그아웃', onTap: _handleLogout),

              const Spacer(),

              SaveProfileButton(onPressed: _saveProfile),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountSecurityTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _AccountSecurityTile({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.centerLeft,
          side: const BorderSide(color: Color(0xFFDADADA)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFF9E9E9E)),
          ],
        ),
      ),
    );
  }
}
