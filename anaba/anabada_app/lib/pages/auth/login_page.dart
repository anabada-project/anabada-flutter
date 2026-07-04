import 'package:flutter/material.dart';

import '../../constants/app_routes.dart';
import '../../controllers/app_controller.dart';
import '../../models/app_user.dart';
import '../../services/auth_api_service.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/app_text_form_field.dart';
import 'find_password_page.dart';
import 'sign_up_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  bool _isLoading = false;

  bool get _isButtonActive {
    return _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        !_isLoading;
  }

  void _clearEmailError(String _) {
    if (_emailError == null) {
      return;
    }

    setState(() {
      _emailError = null;
    });
  }

  void _clearPasswordError(String _) {
    if (_passwordError == null) {
      return;
    }

    setState(() {
      _passwordError = null;
    });
  }

  Future<void> _handleLogin() async {
    final String id = _emailController.text.trim();
    final String password = _passwordController.text;

    if (id.isEmpty || password.isEmpty) {
      setState(() {
        _emailError = id.isEmpty ? '아이디를 입력해주세요.' : null;
        _passwordError = password.isEmpty ? '비밀번호를 입력해주세요.' : null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _emailError = null;
      _passwordError = null;
    });

    try {
      final AppUser? user = await authService.loginWithApi(
        id: id,
        password: password,
      );

      if (!mounted) {
        return;
      }

      if (user == null) {
        setState(() {
          _emailError = '아이디 또는 비밀번호를 다시 확인해주세요.';
          _passwordError = '아이디 또는 비밀번호를 다시 확인해주세요.';
        });
        return;
      }

      debugPrint('로그인 성공');
      debugPrint('accessToken: ${authService.accessToken}');
      debugPrint('refreshToken: ${authService.refreshToken}');

      try {
        await appController.refresh();
      } catch (error) {
        debugPrint('Initial API data refresh failed: $error');
      }

      if (!mounted) {
        return;
      }

      Navigator.pushReplacementNamed(
        context,
        user.isAdmin ? AppRoutes.adminMain : AppRoutes.main,
      );
    } on AuthApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _emailError = error.message;
        _passwordError = '아이디 또는 비밀번호를 다시 확인해주세요.';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _emailError = '로그인에 실패했습니다.';
        _passwordError = '잠시 후 다시 시도해주세요.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenHeight * 0.07),
                const SizedBox(
                  height: 56,
                  child: Center(
                    child: Text('로그인', style: AppTextStyles.screenTitle),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                const Text('이메일', style: AppTextStyles.fieldLabel),
                const SizedBox(height: 8),
                AppTextFormField(
                  controller: _emailController,
                  hintText: '이메일을 입력해주세요',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: _clearEmailError,
                  errorText: _emailError,
                ),
                const SizedBox(height: 20),
                const Text('비밀번호', style: AppTextStyles.fieldLabel),
                const SizedBox(height: 8),
                AppTextFormField(
                  controller: _passwordController,
                  hintText: '비밀번호를 입력해주세요',
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onChanged: _clearPasswordError,
                  errorText: _passwordError,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FindPassword()),
                      );
                    },
                    child: const Text(
                      '비밀번호 찾기',
                      style: AppTextStyles.helperText,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                SizedBox(
                  height: 43,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _emailController,
                      _passwordController,
                    ]),
                    builder: (context, child) {
                      return ElevatedButton(
                        onPressed: _isButtonActive ? _handleLogin : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isButtonActive
                              ? AppColors.mainColor
                              : AppColors.lightGray,
                          disabledBackgroundColor: AppColors.lightGray,
                          disabledForegroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _isLoading ? '로그인 중...' : '로그인',
                          style: _isButtonActive
                              ? AppTextStyles.buttonText
                              : AppTextStyles.disabledButtonText,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(color: AppColors.lightGray, thickness: 1),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('or', style: AppTextStyles.helperText),
                    ),
                    Expanded(
                      child: Divider(color: AppColors.lightGray, thickness: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 43,
                  child: OutlinedButton(
                    onPressed: () async {
                      final String? email = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(builder: (_) => const SignUp()),
                      );

                      if (!context.mounted || email == null) {
                        return;
                      }

                      _emailController.text = email;
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.mainColor,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '회원가입',
                      style: AppTextStyles.outlineButtonText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
