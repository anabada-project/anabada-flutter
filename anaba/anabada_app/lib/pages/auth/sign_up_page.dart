import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_selectable_button.dart';
import '../../widgets/common/app_text_form_field.dart';
import '../../widgets/auth/sign_up_widgets.dart';

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

  // ── 인증코드 6칸 ──────────────────────────────────────
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _codeFocusNodes = List.generate(6, (_) => FocusNode());

  // ── 전공 목록 ──────────────────────────────────────────
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

  // ── 상태 ────────────────────────────────────────────────
  String? _selectedMajor;
  String? _selectedGender;
  String? _selectedTerm;

  /// false  → 인증 전
  /// true   → [인증하기] 눌러서 코드 입력칸 보이는 중
  bool _isCodeSent = false;
  bool _isEmailVerified = false;

  String? _passwordError;
  String? _passwordConfirmError;
  String? _emailError;

  // ── 버튼 활성화 ─────────────────────────────────────────
  bool get _isButtonActive =>
      _nameController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _passwordConfirmController.text.isNotEmpty &&
      _selectedMajor != null &&
      _selectedGender != null &&
      _selectedTerm != null &&
      _isEmailVerified;

  bool get _isCodeFilled => _codeControllers.every((c) => c.text.isNotEmpty);

  // ── 초기화 / 해제 ────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _nameController.addListener(_refresh);
    _emailController.addListener(_handleEmailChanged);
    _passwordController.addListener(_refresh);
    _passwordConfirmController.addListener(_refresh);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    for (final c in _codeControllers) {
      c.dispose();
    }
    for (final f in _codeFocusNodes) {
      f.dispose();
    }
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  // ── 핸들러 ───────────────────────────────────────────────
  void _refresh() {
    if (!mounted) return;
    setState(() {});
  }

  void _handleEmailChanged() {
    if (!mounted) return;
    setState(() {
      // 이메일을 바꾸면 인증 초기화
      _isCodeSent = false;
      _isEmailVerified = false;
      _emailError = null;
      for (final c in _codeControllers) {
        c.clear();
      }
    });
  }

  /// [인증하기] 버튼 클릭 → 코드 입력칸 등장
  void _handleSendCode() {
    final String email = _emailController.text.trim();
    if (email.isEmpty) return;
    final String? code = authService.requestVerificationCode(
      email: email,
      purpose: EmailVerificationPurpose.signUp,
    );
    if (code == null) {
      setState(() {
        _emailError = authService.isEmailRegistered(email)
            ? '이미 가입된 이메일입니다.'
            : '올바른 이메일을 입력해주세요.';
      });
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _emailError = null;
      _isCodeSent = true;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('테스트 인증코드: $code')));
    // 첫 번째 칸에 자동 포커스
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _codeFocusNodes[0].requestFocus();
    });
  }

  /// [재전송] 클릭 → 코드 칸 초기화
  void _handleResendCode() {
    final String? code = authService.requestVerificationCode(
      email: _emailController.text,
      purpose: EmailVerificationPurpose.signUp,
    );
    for (final c in _codeControllers) {
      c.clear();
    }
    _codeFocusNodes[0].requestFocus();
    setState(() {});
    if (code != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('테스트 인증코드: $code')));
    }
  }

  /// [인증완료] 버튼 클릭 → 인증 완료 처리
  void _handleVerifyCode() {
    final String code = _codeControllers.map((controller) {
      return controller.text;
    }).join();
    if (!authService.verifyCode(email: _emailController.text, code: code)) {
      setState(() {
        _emailError = '인증코드가 올바르지 않습니다.';
      });
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _emailError = null;
      _isEmailVerified = true;
      _isCodeSent = false; // 코드 입력칸 숨기기
    });
  }

  // ── 인증코드 입력 핸들러 ─────────────────────────────────
  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _codeFocusNodes[index + 1].requestFocus();
    }
    setState(() {});
  }

  KeyEventResult _onCodeKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _codeControllers[index].text.isEmpty &&
        index > 0) {
      _codeFocusNodes[index - 1].requestFocus();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  // ── 비밀번호 검사 ────────────────────────────────────────
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
      final didSignUp = authService.signUp(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        major: _selectedMajor!,
        gender: _selectedGender!,
        generation: _selectedTerm!,
      );

      if (!didSignUp) {
        setState(() {
          _emailError = '이미 가입된 이메일입니다.';
          _isEmailVerified = false;
        });
        return;
      }

      debugPrint('회원가입 성공');
      Navigator.pop(context, _emailController.text.trim().toLowerCase());
    }
  }

  // ── 빌드 ────────────────────────────────────────────────
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
              // ── 이름 ──────────────────────────────────────
              const AuthFieldLabel('이름'),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _nameController,
                hintText: '이름을 입력해주세요',
              ),
              const SizedBox(height: 20),

              // ── 이메일 ────────────────────────────────────
              const AuthFieldLabel('이메일'),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextFormField(
                      controller: _emailController,
                      hintText: '이메일을 입력해주세요',
                      keyboardType: TextInputType.emailAddress,
                      errorText: _emailError,
                      enabled: !_isEmailVerified && !_isCodeSent,
                      fillColor: (_isEmailVerified || _isCodeSent)
                          ? const Color(0xFFF6F7F8)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  EmailVerificationButton(
                    isVerified: _isEmailVerified,
                    isCodeSent: _isCodeSent,
                    onSend: _handleSendCode,
                    onVerify: _handleVerifyCode,
                    isCodeFilled: _isCodeFilled,
                  ),
                ],
              ),

              // ── 인증코드 입력칸 (코드 전송 후 ~ 인증 완료 전) ───
              if (_isCodeSent && !_isEmailVerified) ...[
                const SizedBox(height: 12),
                Row(
                  children: List.generate(6, (i) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: i < 5 ? 8 : 0),
                        child: Focus(
                          onKeyEvent: (_, event) => _onCodeKeyEvent(event, i),
                          child: TextFormField(
                            controller: _codeControllers[i],
                            focusNode: _codeFocusNodes[i],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            cursorColor: AppColors.mainColor,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 13,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.lightGray,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.mainColor,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            onChanged: (v) => _onCodeChanged(v, i),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _handleResendCode,
                    child: const Text('재전송', style: AppTextStyles.helperText),
                  ),
                ),
              ],

              // ── 인증 완료 안내 ────────────────────────────
              if (_isEmailVerified) ...[
                const SizedBox(height: 6),
                const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.mainColor,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '이메일 인증이 완료되었습니다.',
                      style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 20),

              // ── 비밀번호 ──────────────────────────────────
              const AuthFieldLabel('비밀번호'),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _passwordController,
                hintText: '비밀번호를 입력해주세요',
                obscureText: true,
                errorText: _passwordError,
              ),
              const SizedBox(height: 20),

              // ── 비밀번호 확인 ─────────────────────────────
              const AuthFieldLabel('비밀번호 확인'),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _passwordConfirmController,
                hintText: '비밀번호를 재입력해주세요',
                obscureText: true,
                errorText: _passwordConfirmError,
              ),
              const SizedBox(height: 20),

              // ── 전공 ──────────────────────────────────────
              const AuthFieldLabel('전공'),
              const SizedBox(height: 8),
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
                items: _majors.map((m) {
                  return DropdownMenuItem<String>(
                    value: m,
                    child: Text(m, style: AppTextStyles.fieldText),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedMajor = v),
              ),
              const SizedBox(height: 20),

              // ── 성별 ──────────────────────────────────────
              const AuthFieldLabel('성별'),
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

              // ── 기수 ──────────────────────────────────────
              const AuthFieldLabel('기수'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: SignUpTermButton(
                      text: '8기',
                      isSelected: _selectedTerm == '8기',
                      onTap: () => setState(() => _selectedTerm = '8기'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SignUpTermButton(
                      text: '9기',
                      isSelected: _selectedTerm == '9기',
                      onTap: () => setState(() => _selectedTerm = '9기'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SignUpTermButton(
                      text: '10기',
                      isSelected: _selectedTerm == '10기',
                      onTap: () => setState(() => _selectedTerm = '10기'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // ── 회원가입 버튼 ─────────────────────────────
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
