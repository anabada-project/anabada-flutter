import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widget/app_text_form_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  bool get _isButtonActive =>
      _nameController.text.isNotEmpty &&
      _idController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _passwordConfirmController.text.isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
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
        leadingWidth: 90,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 16),
            child: const Row(
              children: [
                Icon(Icons.arrow_back_ios, size: 14, color: Colors.grey),
                Text(
                  '뒤로가기',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        title: const Text('회원가입', style: AppTextStyles.screenTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              const Text('이름', style: AppTextStyles.fieldLabel),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _nameController,
                hintText: '이름을 입력해주세요',
              ),
              const SizedBox(height: 20),
              const Text('아이디', style: AppTextStyles.fieldLabel),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _idController,
                hintText: '아이디를 입력해주세요',
              ),
              const SizedBox(height: 20),
              const Text('이메일', style: AppTextStyles.fieldLabel),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _emailController,
                hintText: '이메일을 입력해주세요',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              const Text('비밀번호', style: AppTextStyles.fieldLabel),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _passwordController,
                hintText: '비밀번호를 입력해주세요',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              const Text('비밀번호 확인', style: AppTextStyles.fieldLabel),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _passwordConfirmController,
                hintText: '비밀번호를 다시 입력해주세요',
                obscureText: true,
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 43,
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _nameController,
                    _idController,
                    _emailController,
                    _passwordController,
                    _passwordConfirmController,
                  ]),
                  builder: (context, child) {
                    return ElevatedButton(
                      onPressed: _isButtonActive
                          ? () {
                              print('가입하기 클릭!');
                            }
                          : null,
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
                        '가입하기',
                        style: _isButtonActive
                            ? AppTextStyles.buttonText
                            : AppTextStyles.disabledButtonText,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
