import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../services/auth_service.dart';
import '../widget/app_button.dart';
import '../widget/app_text_form_field.dart';
import 'login.dart';

// ── Step 열거형 ──────────────────────────────────────────
enum _Step { email, code, newPassword, success }

class FindPassword extends StatefulWidget {
  const FindPassword({super.key});

  @override
  State<FindPassword> createState() => _FindPasswordState();
}

class _FindPasswordState extends State<FindPassword> {
  // ── 상태 ────────────────────────────────────────────────
  _Step _currentStep = _Step.email;

  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _codeFocusNodes = List.generate(6, (_) => FocusNode());
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  String? _passwordConfirmError;
  String? _emailError;
  String? _codeError;

  // ── 버튼 활성화 조건 ─────────────────────────────────────
  bool get _isEmailButtonActive => _emailController.text.trim().isNotEmpty;

  bool get _isCodeButtonActive =>
      _codeControllers.every((c) => c.text.isNotEmpty);

  bool get _isPasswordButtonActive =>
      _passwordController.text.isNotEmpty &&
      _passwordConfirmController.text.isNotEmpty;

  // ── 핸들러 ───────────────────────────────────────────────
  void _handleSendCode() {
    final String email = _emailController.text.trim();
    final String? code = authService.requestVerificationCode(
      email: email,
      purpose: EmailVerificationPurpose.passwordReset,
    );
    if (code == null) {
      setState(() {
        _emailError = '가입된 이메일을 입력해주세요.';
      });
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _emailError = null;
      _currentStep = _Step.code;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('테스트 인증코드: $code')),
    );
  }

  void _handleResendCode() {
    final String? code = authService.requestVerificationCode(
      email: _emailController.text,
      purpose: EmailVerificationPurpose.passwordReset,
    );
    for (final c in _codeControllers) {
      c.clear();
    }
    _codeFocusNodes[0].requestFocus();
    setState(() {
      _codeError = null;
    });
    if (code != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('테스트 인증코드: $code')),
      );
    }
  }

  void _handleVerifyCode() {
    final String code = _codeControllers
        .map((controller) => controller.text)
        .join();
    if (!authService.verifyCode(
      email: _emailController.text,
      code: code,
    )) {
      setState(() {
        _codeError = '인증코드가 올바르지 않습니다.';
      });
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _codeError = null;
      _currentStep = _Step.newPassword;
    });
  }

  void _handleChangePassword() {
    final String password = _passwordController.text;
    if (password.length < 8 ||
        !RegExp(r'[A-Za-z]').hasMatch(password) ||
        !RegExp(r'\d').hasMatch(password)) {
      setState(() {
        _passwordConfirmError = '영문과 숫자를 포함해 8자 이상 입력해주세요.';
      });
      return;
    }
    if (_passwordController.text != _passwordConfirmController.text) {
      setState(() => _passwordConfirmError = '비밀번호가 일치하지 않습니다.');
      return;
    }
    final bool didReset = authService.resetPassword(
      email: _emailController.text,
      newPassword: password,
    );
    if (!didReset) {
      setState(() {
        _passwordConfirmError = '비밀번호를 변경하지 못했습니다.';
      });
      return;
    }
    setState(() {
      _passwordConfirmError = null;
      _currentStep = _Step.success;
    });
  }

  void _handleGoLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
      (route) => false,
    );
  }

  // ── 인증코드 입력 핸들러 ──────────────────────────────────
  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _codeFocusNodes[index + 1].requestFocus();
    }
    setState(() {});
  }

  void _onCodeKeyDown(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _codeControllers[index].text.isEmpty &&
        index > 0) {
      _codeFocusNodes[index - 1].requestFocus();
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _passwordConfirmController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
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
        title: Text(
          _currentStep == _Step.newPassword ? '새 비밀번호 설정' : '비밀번호 찾기',
          style: AppTextStyles.screenTitle,
        ),
        actions: const [SizedBox(width: 100)],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Step별 본문 ──────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      _buildSubtitle(),
                      const SizedBox(height: 28),
                      _buildBody(),
                    ],
                  ),
                ),
              ),
              // ── 하단 버튼 ────────────────────────────────
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ── 부제목 ───────────────────────────────────────────────
  Widget _buildSubtitle() {
    final String text = switch (_currentStep) {
      _Step.email => '가입하신 이메일을 입력해주세요',
      _Step.code => '이메일로 발송된 6자리 인증 코드를\n입력해주세요.',
      _Step.newPassword => '새로운 비밀번호를 입력해주세요.',
      _Step.success => '',
    };

    if (text.isEmpty) return const SizedBox.shrink();

    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: AppColors.grayText,
        fontSize: 12,
        height: 1.5,
      ),
    );
  }

  // ── Step별 본문 위젯 ─────────────────────────────────────
  Widget _buildBody() {
    return switch (_currentStep) {
      _Step.email => _EmailStep(
        controller: _emailController,
        errorText: _emailError,
      ),
      _Step.code => _CodeStep(
        controllers: _codeControllers,
        focusNodes: _codeFocusNodes,
        onChanged: _onCodeChanged,
        onKeyDown: _onCodeKeyDown,
        onResend: _handleResendCode,
        errorText: _codeError,
      ),
      _Step.newPassword => _NewPasswordStep(
        passwordController: _passwordController,
        confirmController: _passwordConfirmController,
        passwordConfirmError: _passwordConfirmError,
      ),
      _Step.success => const _SuccessStep(),
    };
  }

  // ── 하단 버튼 ────────────────────────────────────────────
  Widget _buildBottomButton() {
    return switch (_currentStep) {
      _Step.email => AppButton(
        text: '인증 코드 보내기',
        isActive: _isEmailButtonActive,
        onPressed: _handleSendCode,
      ),
      _Step.code => AppButton(
        text: '확인',
        isActive: _isCodeButtonActive,
        onPressed: _handleVerifyCode,
      ),
      _Step.newPassword => AppButton(
        text: '변경하기',
        isActive: _isPasswordButtonActive,
        onPressed: _handleChangePassword,
      ),
      _Step.success => AppButton(
        text: '로그인 하러 가기',
        isActive: true,
        onPressed: _handleGoLogin,
      ),
    };
  }
}

// ── Step 1: 이메일 입력 ──────────────────────────────────
class _EmailStep extends StatelessWidget {
  const _EmailStep({required this.controller, required this.errorText});

  final TextEditingController controller;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('이메일', style: AppTextStyles.fieldLabel),
        const SizedBox(height: 8),
        AppTextFormField(
          controller: controller,
          hintText: '이메일을 입력해주세요',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          errorText: errorText,
        ),
      ],
    );
  }
}

// ── Step 2: 인증코드 입력 ────────────────────────────────
class _CodeStep extends StatelessWidget {
  const _CodeStep({
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
    required this.onKeyDown,
    required this.onResend,
    required this.errorText,
  });

  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(String, int) onChanged;
  final void Function(KeyEvent, int) onKeyDown;
  final VoidCallback onResend;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('인증코드', style: AppTextStyles.fieldLabel),
        const SizedBox(height: 8),
        Row(
          children: List.generate(6, (i) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < 5 ? 8 : 0),
                child: KeyboardListener(
                  focusNode: focusNodes[i],
                  onKeyEvent: (event) => onKeyDown(event, i),
                  child: TextFormField(
                    controller: controllers[i],
                    focusNode: focusNodes[i],
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
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
                    onChanged: (v) => onChanged(v, i),
                  ),
                ),
              ),
            );
          }),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: onResend,
            child: const Text('재전송', style: AppTextStyles.helperText),
          ),
        ),
      ],
    );
  }
}

// ── Step 3: 새 비밀번호 설정 ─────────────────────────────
class _NewPasswordStep extends StatelessWidget {
  const _NewPasswordStep({
    required this.passwordController,
    required this.confirmController,
    required this.passwordConfirmError,
  });

  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final String? passwordConfirmError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('새 비밀번호', style: AppTextStyles.fieldLabel),
        const SizedBox(height: 8),
        AppTextFormField(
          controller: passwordController,
          hintText: '비밀번호를 입력하세요.',
          obscureText: true,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),
        const Text('새 비밀번호 확인', style: AppTextStyles.fieldLabel),
        const SizedBox(height: 8),
        AppTextFormField(
          controller: confirmController,
          hintText: '비밀번호를 다시 입력하세요.',
          obscureText: true,
          textInputAction: TextInputAction.done,
          errorText: passwordConfirmError,
        ),
        // ── 에러 메시지 ──────────────────────────────────
        if (passwordConfirmError != null) ...[
          const SizedBox(height: 8),
          Text(
            passwordConfirmError!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }
}

// ── Step 4: 성공 화면 ────────────────────────────────────
class _SuccessStep extends StatelessWidget {
  const _SuccessStep();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.mainColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: AppColors.mainColor, size: 36),
        ),
        const SizedBox(height: 24),
        const Text(
          '비밀번호가 성공적으로 변경되었습니다.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '새 비밀번호로 로그인 할 수 있습니다.\n안전한 계정 사용을 위해 주기적으로\n비밀번호를 변경해주세요.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grayText,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
