import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../controllers/app_controller.dart';
import '../services/auth_api_service.dart';
import '../services/auth_service.dart';
import '../widgets/edit_profile_header.dart';
import '../widgets/edit_profile_input_field.dart';
import '../widgets/generation_button.dart';
import '../widgets/save_profile_button.dart';
import 'auth/find_password_page.dart';
import 'auth/login_page.dart';

class EditProfileResult {
  final String name;
  final String email;
  final String major;
  final String generation;

  const EditProfileResult({
    required this.name,
    required this.email,
    required this.major,
    required this.generation,
  });
}

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
  static const List<_MajorOption> _majorOptions = [
    _MajorOption(label: '백엔드', value: 'BACKEND'),
    _MajorOption(label: '프론트엔드', value: 'FRONTEND'),
    _MajorOption(label: '디자인', value: 'DESIGN'),
    _MajorOption(label: '플러터', value: 'FLUTTER'),
    _MajorOption(label: 'iOS', value: 'IOS'),
    _MajorOption(label: '안드로이드', value: 'ANDROID'),
    _MajorOption(label: '기획', value: 'PM'),
    _MajorOption(label: 'AI', value: 'AI'),
  ];

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  late String selectedGeneration;
  String? _selectedMajor;

  String? nameErrorText;
  String? majorErrorText;

  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _selectedMajor = _normalizeMajor(widget.initialMajor);
    selectedGeneration = widget.initialGeneration;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  String? _normalizeMajor(String major) {
    final String normalizedMajor = major.trim().toUpperCase();

    for (final _MajorOption option in _majorOptions) {
      if (option.value == normalizedMajor || option.label == major.trim()) {
        return option.value;
      }
    }

    return null;
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

  void _selectMajor(String? major) {
    setState(() {
      _selectedMajor = major;
      majorErrorText = null;
    });
  }

  Future<void> _saveProfile() async {
    final String name = _nameController.text.trim();
    final String? major = _selectedMajor;

    setState(() {
      nameErrorText = name.isEmpty ? '이름을 입력해주세요.' : null;
      majorErrorText = major == null ? '전공을 선택해주세요.' : null;
    });

    if (name.isEmpty || major == null) {
      return;
    }

    final updatedUser = authService.updateProfile(
      name: name,
      major: major,
      generation: selectedGeneration,
    );

    if (updatedUser == null) {
      return;
    }

    await appController.updateOwnerProfile(
      ownerId: updatedUser.id,
      ownerName: updatedUser.name,
      ownerGeneration: updatedUser.generation,
    );

    if (!mounted) {
      return;
    }

    Navigator.pop(
      context,
      EditProfileResult(
        name: updatedUser.name,
        email: updatedUser.email,
        major: updatedUser.major,
        generation: updatedUser.generation,
      ),
    );
  }

  void _handleResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FindPassword()),
    );
  }

  Future<void> _handleLogout() async {
    if (_isLoggingOut) {
      return;
    }

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await authService.logoutWithApi();
    } on AuthApiException catch (error) {
      debugPrint('로그아웃 API 실패: ${error.message}');
    } catch (error) {
      debugPrint('로그아웃 처리 실패: $error');
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoggingOut = false;
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
      (route) => false,
    );
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

              _MajorDropdown(
                options: _majorOptions,
                selectedMajor: _selectedMajor,
                errorText: majorErrorText,
                onChanged: _selectMajor,
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

              _AccountSecurityTile(
                text: _isLoggingOut ? '로그아웃 중...' : '로그아웃',
                onTap: () {
                  _handleLogout();
                },
              ),

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

class _MajorDropdown extends StatelessWidget {
  const _MajorDropdown({
    required this.options,
    required this.selectedMajor,
    required this.errorText,
    required this.onChanged,
  });

  final List<_MajorOption> options;
  final String? selectedMajor;
  final String? errorText;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('전공', style: AppTextStyles.editLabel),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          initialValue: selectedMajor,
          isExpanded: true,
          dropdownColor: Colors.white,
          menuMaxHeight: 360,
          hint: const Text(
            '전공을 선택해주세요.',
            style: AppTextStyles.hintText,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.grayText,
            size: 22,
          ),
          style: const TextStyle(fontSize: 15, color: Colors.black),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? Colors.red : const Color(0xFFDADADA),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? Colors.red : AppColors.mainColor,
              ),
            ),
          ),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option.value,
              child: Text(option.label),
            );
          }).toList(),
          selectedItemBuilder: (context) {
            return options.map((option) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(option.label),
              );
            }).toList();
          },
          onChanged: onChanged,
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}

class _MajorOption {
  const _MajorOption({required this.label, required this.value});

  final String label;
  final String value;
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
