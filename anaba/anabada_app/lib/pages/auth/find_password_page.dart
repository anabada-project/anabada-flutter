import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/auth_api_service.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/auth/password_reset_steps.dart';
import '../../widgets/common/app_button.dart';
import 'login_page.dart';

enum _Step { email, code, newPassword, success }

class FindPassword extends StatefulWidget {
  const FindPassword({super.key});

  @override
  State<FindPassword> createState() => _FindPasswordState();
}

class _FindPasswordState extends State<FindPassword> {
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
  bool _isLoading = false;

  bool get _isEmailButtonActive =>
      _emailController.text.trim().isNotEmpty && !_isLoading;

  bool get _isCodeButtonActive =>
      _codeControllers.every((controller) => controller.text.isNotEmpty) &&
      !_isLoading;

  bool get _isPasswordButtonActive =>
      _passwordController.text.isNotEmpty &&
      _passwordConfirmController.text.isNotEmpty &&
      !_isLoading;

  Future<void> _handleSendCode() async {
    if (_isLoading) {
      return;
    }

    final String email = _emailController.text.trim();

    if (!_isValidEmail(email)) {
      setState(() {
        _emailError = '가입된 이메일을 입력해주세요.';
      });
      return;
    }

    setState(() {
      _emailError = null;
      _isLoading = true;
    });

    try {
      final AuthApiMessageResult result = await authService
          .requestPasswordResetCodeWithApi(email: email);

      if (!mounted) {
        return;
      }

      _clearCodeControllers();
      FocusScope.of(context).unfocus();

      setState(() {
        _emailError = null;
        _codeError = null;
        _currentStep = _Step.code;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _codeFocusNodes[0].requestFocus();
        }
      });
    } on AuthApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _emailError = error.message;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint('비밀번호 재설정 인증번호 발송 실패: $error');

      const String message = '인증번호 발송에 실패했습니다. 잠시 후 다시 시도해주세요.';
      setState(() {
        _emailError = message;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleResendCode() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _codeError = null;
      _isLoading = true;
    });

    try {
      final AuthApiMessageResult result = await authService
          .requestPasswordResetCodeWithApi(email: _emailController.text);

      if (!mounted) {
        return;
      }

      _clearCodeControllers();
      _codeFocusNodes[0].requestFocus();

      setState(() {
        _codeError = null;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));
    } on AuthApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _codeError = error.message;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint('비밀번호 재설정 인증번호 재발송 실패: $error');

      const String message = '인증번호 재발송에 실패했습니다. 잠시 후 다시 시도해주세요.';
      setState(() {
        _codeError = message;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleVerifyCode() async {
    if (_isLoading) {
      return;
    }

    final String code = _codeControllers
        .map((controller) => controller.text)
        .join();

    if (code.length < 6) {
      setState(() {
        _codeError = '인증번호 6자리를 모두 입력해주세요.';
      });
      return;
    }

    setState(() {
      _codeError = null;
      _isLoading = true;
    });

    try {
      final AuthApiMessageResult result = await authService
          .verifyPasswordResetCodeWithApi(
            email: _emailController.text,
            code: code,
          );

      if (!mounted) {
        return;
      }

      FocusScope.of(context).unfocus();

      setState(() {
        _codeError = null;
        _currentStep = _Step.newPassword;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));
    } on AuthApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _codeError = error.message;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint('비밀번호 재설정 인증번호 검증 실패: $error');

      const String message = '인증번호 확인에 실패했습니다. 잠시 후 다시 시도해주세요.';
      setState(() {
        _codeError = message;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleChangePassword() async {
    if (_isLoading) {
      return;
    }

    final String password = _passwordController.text;
    final String confirmPassword = _passwordConfirmController.text;

    if (password.length < 8 ||
        !RegExp(r'[A-Za-z]').hasMatch(password) ||
        !RegExp(r'\d').hasMatch(password)) {
      setState(() {
        _passwordConfirmError = '영문과 숫자를 포함해 8자 이상 입력해주세요.';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _passwordConfirmError = '비밀번호가 일치하지 않습니다.';
      });
      return;
    }

    setState(() {
      _passwordConfirmError = null;
      _isLoading = true;
    });

    try {
      final AuthApiMessageResult result = await authService
          .resetPasswordWithApi(
            email: _emailController.text,
            newPassword: password,
            confirmPassword: confirmPassword,
          );

      if (!mounted) {
        return;
      }

      setState(() {
        _passwordConfirmError = null;
        _currentStep = _Step.success;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));
    } on AuthApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _passwordConfirmError = error.message;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint('비밀번호 재설정 실패: $error');

      const String message = '비밀번호 변경에 실패했습니다. 잠시 후 다시 시도해주세요.';
      setState(() {
        _passwordConfirmError = message;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleGoLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
      (route) => false,
    );
  }

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

  void _clearCodeControllers() {
    for (final TextEditingController controller in _codeControllers) {
      controller.clear();
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
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

    for (final TextEditingController controller in _codeControllers) {
      controller.dispose();
    }

    for (final FocusNode focusNode in _codeFocusNodes) {
      focusNode.dispose();
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
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    final String text = switch (_currentStep) {
      _Step.email => '가입하신 이메일을 입력해주세요',
      _Step.code => '이메일로 발송된 6자리 인증 코드를\n입력해주세요.',
      _Step.newPassword => '새로운 비밀번호를 입력해주세요.',
      _Step.success => '',
    };

    if (text.isEmpty) {
      return const SizedBox.shrink();
    }

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

  Widget _buildBottomButton() {
    return switch (_currentStep) {
      _Step.email => AppButton(
        text: _isLoading ? '발송 중...' : '인증 코드 보내기',
        isActive: _isEmailButtonActive,
        onPressed: _handleSendCode,
      ),
      _Step.code => AppButton(
        text: _isLoading ? '확인 중...' : '확인',
        isActive: _isCodeButtonActive,
        onPressed: _handleVerifyCode,
      ),
      _Step.newPassword => AppButton(
        text: _isLoading ? '변경 중...' : '변경하기',
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
