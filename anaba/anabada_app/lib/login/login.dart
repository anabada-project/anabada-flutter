import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widget/app_text_form_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isButtonActive = false;

  @override
  void initState() {
    super.initState();

    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonActive =
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
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
                Container(
                  height: 56,
                  alignment: Alignment.center,
                  child: const Text('로그인', style: AppTextStyles.screenTitle),
                ),
                SizedBox(height: screenHeight * 0.03),
                const Text('이메일', style: AppTextStyles.fieldLabel),
                const SizedBox(height: 8),
                AppTextFormField(
                  controller: _emailController,
                  hintText: '이메일을 입력해주세요',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                const Text('비밀번호', style: AppTextStyles.fieldLabel),
                const SizedBox(height: 8),
                AppTextFormField(
                  controller: _passwordController,
                  hintText: '비밀번호를 입력해주세요',
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      '비밀번호 찾기',
                      style: AppTextStyles.helperText,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                SizedBox(
                  height: 43,
                  child: ElevatedButton(
                    onPressed: _isButtonActive ? () {} : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isButtonActive
                          ? AppColors.mainColor
                          : AppColors.lightGray,
                      disabledBackgroundColor: AppColors.lightGray,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '로그인',
                      style: _isButtonActive
                          ? AppTextStyles.buttonText
                          : AppTextStyles.disabledButtonText,
                    ),
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
                    onPressed: () {},
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
