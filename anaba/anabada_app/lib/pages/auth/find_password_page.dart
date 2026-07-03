import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/auth/password_reset_steps.dart';
import '../../widgets/common/app_button.dart';
import 'login_page.dart';

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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('테스트 인증코드: $code')));
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('테스트 인증코드: $code')));
    }
  }

  void _handleVerifyCode() {
    final String code = _codeControllers
        .map((controller) => controller.text)
        .join();
    if (!authService.verifyCode(email: _emailController.text, code: code)) {
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
      _Step.email => PasswordResetEmailStep(
        controller: _emailController,
        errorText: _emailError,
      ),
      _Step.code => PasswordResetCodeStep(
        controllers: _codeControllers,
        focusNodes: _codeFocusNodes,
        onChanged: _onCodeChanged,
        onKeyDown: _onCodeKeyDown,
        onResend: _handleResendCode,
        errorText: _codeError,
      ),
      _Step.newPassword => PasswordResetNewPasswordStep(
        passwordController: _passwordController,
        confirmController: _passwordConfirmController,
        passwordConfirmError: _passwordConfirmError,
      ),
      _Step.success => const PasswordResetSuccessStep(),
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
