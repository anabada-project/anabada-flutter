import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../common/app_selectable_button.dart';

class EmailVerificationButton extends StatelessWidget {
  const EmailVerificationButton({
    super.key,
    required this.isVerified,
    required this.isCodeSent,
    required this.onSend,
    required this.onVerify,
    required this.isCodeFilled,
    required this.isLoading,
  });

  final bool isVerified;
  final bool isCodeSent;
  final VoidCallback onSend;
  final VoidCallback onVerify;
  final bool isCodeFilled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 88,
        height: 43,
        child: ElevatedButton(
          onPressed: null,
          style: _elevatedStyle(),
          child: const Text('전송중', style: AppTextStyles.disabledButtonText),
        ),
      );
    }

    if (isVerified) {
      return SizedBox(
        width: 88,
        height: 43,
        child: ElevatedButton(
          onPressed: null,
          style: _elevatedStyle(),
          child: const Text('인증완료', style: AppTextStyles.disabledButtonText),
        ),
      );
    }

    if (isCodeSent) {
      return SizedBox(
        width: 88,
        height: 43,
        child: ElevatedButton(
          onPressed: isCodeFilled ? onVerify : null,
          style: _elevatedStyle(backgroundColor: AppColors.mainColor),
          child: Text(
            '확인',
            style: AppTextStyles.disabledButtonText.copyWith(
              color: isCodeFilled ? Colors.white : null,
            ),
          ),
        ),
      );
    }

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

  ButtonStyle _elevatedStyle({Color? backgroundColor}) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      disabledBackgroundColor: const Color(0xFFEFF0F2),
      disabledForegroundColor: Colors.white,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.zero,
    );
  }
}

class SignUpTermButton extends StatelessWidget {
  const SignUpTermButton({
    super.key,
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

class AuthFieldLabel extends StatelessWidget {
  const AuthFieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.fieldLabel);
  }
}
