import 'package:flutter/material.dart';

//디자인 색깔 따온거
class AppColors {
  static const Color mainColor = Color(0xFFFFB800);
  static const Color grayText = Color(0xFF9E9E9E);
  static const Color lightGray = Color(0xFFF3F3F3);
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // 이메일과 비밀번호 입력을 실시간으로 감지할 컨트롤러
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 버튼 활성화 상태를 저장하는 변수
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
    // 기기의 화면 높이를 가져와서 활용
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenHeight * 0.07),

                // [1. 상단 타이틀 ]
                Container(
                  height: 56,
                  alignment: Alignment.center,
                  child: const Text(
                    '로그인',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // 사이에 간격주기
                SizedBox(height: screenHeight * 0.03),

                // [2. 이메일 ]
                const Text(
                  '이메일',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: '이메일을 입력해주세요',
                    hintStyle: const TextStyle(
                      color: AppColors.grayText,
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.mainColor,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.lightGray),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // [3. 비밀번호 섹션]
                const Text(
                  '비밀번호',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '비밀번호를 입력해주세요',
                    hintStyle: const TextStyle(
                      color: AppColors.grayText,
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.mainColor,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.lightGray),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // [4. 비밀번호 찾기]
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      '비밀번호 찾기',
                      style: TextStyle(color: AppColors.grayText, fontSize: 12),
                    ),
                  ),
                ),

                // 사이 간격 주기
                SizedBox(height: screenHeight * 0.05),

                // [5. 로그인 버튼]
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
                      style: TextStyle(
                        color: _isButtonActive
                            ? Colors.white
                            : AppColors.grayText,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // [6. 중간 'or' 구분선]
                Row(
                  children: const [
                    Expanded(
                      child: Divider(color: AppColors.lightGray, thickness: 1),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'or',
                        style: TextStyle(
                          color: AppColors.grayText,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: AppColors.lightGray, thickness: 1),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // [7. 회원가입 버튼]
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
                      style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
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
