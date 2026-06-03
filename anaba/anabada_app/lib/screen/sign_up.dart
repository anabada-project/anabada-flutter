import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widget/app_button.dart';
import '../widget/app_selectable_button.dart';
import '../widget/app_text_form_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  final List<String> _majors = const [
    '백엔드',
    '프론트엔드',
    '디자인',
    '플러터',
    'iOS',
    '안드로이드',
    '기능반',
    'AI',
  ];

  String? _selectedMajor;
  String? _selectedGender;
  String? _selectedTerm;
  bool _isEmailVerified = false;
  String? _passwordError;
  String? _passwordConfirmError;

  bool get _isButtonActive =>
      _nameController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _passwordConfirmController.text.isNotEmpty &&
      _selectedMajor != null &&
      _selectedGender != null &&
      _selectedTerm != null &&
      _isEmailVerified;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_refresh);
    _emailController.addListener(_handleEmailChanged);
    _passwordController.addListener(_refresh);
    _passwordConfirmController.addListener(_refresh);
  }

  void _refresh() {
    if (!mounted) return;
    setState(() {});
  }

  void _handleEmailChanged() {
    if (!mounted) return;
    setState(() {
      _isEmailVerified = false;
    });
  }

  void _handleEmailVerify() {
    if (_emailController.text.trim().isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _isEmailVerified = true;
    });
  }

  bool _isPasswordFormatValid(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Za-z]').hasMatch(password) &&
        RegExp(r'\d').hasMatch(password);
  }

  void _handleSignUp() {
    setState(() {
      _passwordError = _isPasswordFormatValid(_passwordController.text)
          ? null
          : '비밀번호 형식이 잘못되었습니다.';
      _passwordConfirmError =
          _passwordController.text == _passwordConfirmController.text
          ? null
          : '비밀번호가 일치하지 않습니다.';
    });

    if (_passwordError == null && _passwordConfirmError == null) {
      debugPrint('회원가입 성공');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios, size: 13, color: AppColors.grayText),
              SizedBox(width: 2),
              Text('뒤로가기', style: AppTextStyles.helperText),
            ],
          ),
        ),
        title: const Text('회원가입', style: AppTextStyles.screenTitle),
        actions: const [SizedBox(width: 100)],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _FieldLabel('이름'),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _nameController,
                hintText: '이름을 입력해주세요',
              ),
              const SizedBox(height: 20),
              const _FieldLabel('이메일'),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextFormField(
                      controller: _emailController,
                      hintText: '이메일을 입력해주세요',
                      keyboardType: TextInputType.emailAddress,
                      enabled: !_isEmailVerified,
                      fillColor: _isEmailVerified
                          ? const Color(0xFFF6F7F8)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _EmailVerifyButton(
                    isVerified: _isEmailVerified,
                    onPressed: _handleEmailVerify,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const _FieldLabel('비밀번호'),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _passwordController,
                hintText: '비밀번호를 입력해주세요',
                obscureText: true,
                errorText: _passwordError,
              ),
              const SizedBox(height: 20),
              const _FieldLabel('비밀번호 확인'),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _passwordConfirmController,
                hintText: '비밀번호를 재입력해주세요',
                obscureText: true,
                errorText: _passwordConfirmError,
              ),
              const SizedBox(height: 20),
              const _FieldLabel('전공'),
              const SizedBox(height: 8),
              // ✅ Fix: initialValue → value
              DropdownButtonFormField<String>(
                initialValue: _selectedMajor,
                isExpanded: true,
                dropdownColor: Colors.white,
                menuMaxHeight: 360,
                hint: const Text('전공을 선택해주세요', style: AppTextStyles.fieldHint),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.grayText,
                  size: 18,
                ),
                style: AppTextStyles.fieldText,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.lightGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.mainColor,
                      width: 1.5,
                    ),
                  ),
                ),
                items: _majors.map((String major) {
                  return DropdownMenuItem<String>(
                    value: major,
                    child: Text(major, style: AppTextStyles.fieldText),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMajor = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              const _FieldLabel('성별'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: AppSelectableButton(
                      text: '남자',
                      isSelected: _selectedGender == '남자',
                      width: double.infinity,
                      onTap: () => setState(() => _selectedGender = '남자'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppSelectableButton(
                      text: '여자',
                      isSelected: _selectedGender == '여자',
                      width: double.infinity,
                      onTap: () => setState(() => _selectedGender = '여자'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const _FieldLabel('기수'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: AppSelectableButton(
                      text: '8기',
                      isSelected: _selectedTerm == '8기',
                      width: double.infinity,
                      onTap: () => setState(() => _selectedTerm = '8기'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppSelectableButton(
                      text: '9기',
                      isSelected: _selectedTerm == '9기',
                      width: double.infinity,
                      onTap: () => setState(() => _selectedTerm = '9기'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppSelectableButton(
                      text: '10기',
                      isSelected: _selectedTerm == '10기',
                      width: double.infinity,
                      onTap: () => setState(() => _selectedTerm = '10기'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              AppButton(
                text: '회원가입',
                isActive: _isButtonActive,
                onPressed: _handleSignUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.fieldLabel);
  }
}

class _EmailVerifyButton extends StatelessWidget {
  const _EmailVerifyButton({required this.isVerified, required this.onPressed});

  final bool isVerified;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (isVerified) {
      return SizedBox(
        width: 88,
        height: 43,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: const Color(0xFFEFF0F2),
            disabledForegroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.zero,
          ),
          child: const Text('인증완료', style: AppTextStyles.disabledButtonText),
        ),
      );
    }

    return SizedBox(
      width: 88,
      height: 43,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.mainColor,
          side: const BorderSide(color: AppColors.mainColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
        ),
        child: const Text('인증하기', style: AppTextStyles.outlineButtonText),
      ),
    );
  }
}
