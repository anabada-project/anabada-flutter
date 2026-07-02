import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../common/app_text_form_field.dart';

class PasswordResetEmailStep extends StatelessWidget {
  const PasswordResetEmailStep({
    super.key,
    required this.controller,
    required this.errorText,
  });

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

class PasswordResetCodeStep extends StatelessWidget {
  const PasswordResetCodeStep({
    super.key,
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
          children: List.generate(6, (index) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < 5 ? 8 : 0),
                child: KeyboardListener(
                  focusNode: focusNodes[index],
                  onKeyEvent: (event) => onKeyDown(event, index),
                  child: TextFormField(
                    controller: controllers[index],
                    focusNode: focusNodes[index],
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
                    onChanged: (value) => onChanged(value, index),
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

class PasswordResetNewPasswordStep extends StatelessWidget {
  const PasswordResetNewPasswordStep({
    super.key,
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

class PasswordResetSuccessStep extends StatelessWidget {
  const PasswordResetSuccessStep({super.key});

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
          '새 비밀번호로 로그인 할 수 있습니다.\n'
          '안전한 계정 사용을 위해 주기적으로\n'
          '비밀번호를 변경해주세요.',
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
