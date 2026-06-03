import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    for (final c in _codeControllers) c.dispose();
    for (final f in _codeFocusNodes) f.dispose();
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
      for (final c in _codeControllers) c.clear();
    });
  }

  /// [인증하기] 버튼 클릭 → 코드 입력칸 등장
  void _handleSendCode() {
    if (_emailController.text.trim().isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _isCodeSent = true;
    });
    // 첫 번째 칸에 자동 포커스
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _codeFocusNodes[0].requestFocus();
    });
  }

  /// [재전송] 클릭 → 코드 칸 초기화
  void _handleResendCode() {
    for (final c in _codeControllers) c.clear();
    _codeFocusNodes[0].requestFocus();
    setState(() {});
  }

  /// [인증완료] 버튼 클릭 → 인증 완료 처리
  void _handleVerifyCode() {
    FocusScope.of(context).unfocus();
    setState(() {
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

  void _onCodeKeyDown(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _codeControllers[index].text.isEmpty &&
        index > 0) {
      _codeFocusNodes[index - 1].requestFocus();
    }
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
      debugPrint('회원가입 성공');
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
              const _FieldLabel('이름'),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _nameController,
                hintText: '이름을 입력해주세요',
              ),
              const SizedBox(height: 20),

              // ── 이메일 ────────────────────────────────────
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
                      enabled: !_isEmailVerified && !_isCodeSent,
                      fillColor: (_isEmailVerified || _isCodeSent)
                          ? const Color(0xFFF6F7F8)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _EmailActionButton(
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
                        child: RawKeyboardListener(
                          focusNode: FocusNode(),
                          onKey: (event) => _onCodeKeyDown(event, i),
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
              const _FieldLabel('비밀번호'),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _passwordController,
                hintText: '비밀번호를 입력해주세요',
                obscureText: true,
                errorText: _passwordError,
              ),
              const SizedBox(height: 20),

              // ── 비밀번호 확인 ─────────────────────────────
              const _FieldLabel('비밀번호 확인'),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _passwordConfirmController,
                hintText: '비밀번호를 재입력해주세요',
                obscureText: true,
                errorText: _passwordConfirmError,
              ),
              const SizedBox(height: 20),

              // ── 전공 ──────────────────────────────────────
              const _FieldLabel('전공'),
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

              // ── 기수 ──────────────────────────────────────
              const _FieldLabel('기수'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _TermButton(
                      text: '8기',
                      isSelected: _selectedTerm == '8기',
                      onTap: () => setState(() => _selectedTerm = '8기'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _TermButton(
                      text: '9기',
                      isSelected: _selectedTerm == '9기',
                      onTap: () => setState(() => _selectedTerm = '9기'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _TermButton(
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

// ── 이메일 옆 버튼 ────────────────────────────────────────
// 상태에 따라 [인증하기] / [인증완료(비활성)] / [확인] 세 가지로 전환
class _EmailActionButton extends StatelessWidget {
  const _EmailActionButton({
    required this.isVerified,
    required this.isCodeSent,
    required this.onSend,
    required this.onVerify,
    required this.isCodeFilled,
  });

  final bool isVerified;
  final bool isCodeSent;
  final VoidCallback onSend;
  final VoidCallback onVerify;
  final bool isCodeFilled;

  @override
  Widget build(BuildContext context) {
    // 인증 완료 → 회색 비활성 버튼
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

    // 코드 전송 후 → [확인] 버튼 (코드 다 입력해야 활성화)
    if (isCodeSent) {
      return SizedBox(
        width: 88,
        height: 43,
        child: ElevatedButton(
          onPressed: isCodeFilled ? onVerify : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
            disabledBackgroundColor: const Color(0xFFEFF0F2),
            disabledForegroundColor: Colors.white,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Text(
            '확인',
            style: AppTextStyles.disabledButtonText.copyWith(
              color: isCodeFilled ? Colors.white : null,
            ),
          ),
        ),
      );
    }

    // 기본 → [인증하기] OutlinedButton
    return SizedBox(
      width: 88,
      height: 43,
      child: OutlinedButton(
        onPressed: onSend,
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

// ── 기수 버튼 ────────────────────────────────────────────
class _TermButton extends StatelessWidget {
  const _TermButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSelectableButton(
      text: text,
      isSelected: isSelected,
      width: double.infinity,
      onTap: onTap,
    );
  }
}

// ── 필드 레이블 ──────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.fieldLabel);
  }
}
