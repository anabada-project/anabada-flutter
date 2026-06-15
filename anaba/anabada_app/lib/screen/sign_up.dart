import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/auth_api_service.dart';
import '../services/auth_service.dart';
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
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _codeFocusNodes = List.generate(6, (_) => FocusNode());

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

  String? _selectedMajor;
  String? _selectedGender;
  String? _selectedTerm;

  bool _isCodeSent = false;
  bool _isEmailVerified = false;
  bool _isSendingCode = false;
  bool _isVerifyingCode = false;
  bool _isSigningUp = false;

  String? _idError;
  String? _passwordError;
  String? _passwordConfirmError;
  String? _emailError;

  bool get _isButtonActive {
    return _nameController.text.trim().isNotEmpty &&
        _idController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _passwordConfirmController.text.isNotEmpty &&
        _selectedMajor != null &&
        _selectedGender != null &&
        _selectedTerm != null &&
        _isEmailVerified &&
        !_isSigningUp;
  }

  bool get _isCodeFilled {
    return _codeControllers.every((controller) {
      return controller.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();

    _nameController.addListener(_refresh);
    _idController.addListener(_handleIdChanged);
    _emailController.addListener(_handleEmailChanged);
    _passwordController.addListener(_refresh);
    _passwordConfirmController.addListener(_refresh);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
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

  void _refresh() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  void _handleIdChanged() {
    if (!mounted) {
      return;
    }

    setState(() {
      _idError = null;
    });
  }

  void _handleEmailChanged() {
    if (!mounted) {
      return;
    }

    setState(() {
      _isCodeSent = false;
      _isEmailVerified = false;
      _emailError = null;

      for (final TextEditingController controller in _codeControllers) {
        controller.clear();
      }
    });
  }

  Future<void> _handleSendCode() async {
    final String email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _emailError = '이메일을 입력해주세요.';
      });
      return;
    }

    setState(() {
      _isSendingCode = true;
      _emailError = null;
    });

    try {
      await authService.sendSignUpVerificationCode(email: email);

      if (!mounted) {
        return;
      }

      FocusScope.of(context).unfocus();

      setState(() {
        _isCodeSent = true;
        _isEmailVerified = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('인증번호가 발송되었습니다.')));

      Future.delayed(const Duration(milliseconds: 100), () {
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
    } finally {
      if (mounted) {
        setState(() {
          _isSendingCode = false;
        });
      }
    }
  }

  Future<void> _handleResendCode() async {
    for (final TextEditingController controller in _codeControllers) {
      controller.clear();
    }

    setState(() {});

    await _handleSendCode();
  }

  Future<void> _handleVerifyCode() async {
    final String code = _codeControllers.map((controller) {
      return controller.text;
    }).join();

    if (code.length != 6) {
      setState(() {
        _emailError = '인증코드 6자리를 입력해주세요.';
      });
      return;
    }

    setState(() {
      _isVerifyingCode = true;
      _emailError = null;
    });

    try {
      await authService.verifySignUpVerificationCode(
        email: _emailController.text.trim(),
        code: code,
      );

      if (!mounted) {
        return;
      }

      FocusScope.of(context).unfocus();

      setState(() {
        _emailError = null;
        _isEmailVerified = true;
        _isCodeSent = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('이메일 인증이 완료되었습니다.')));
    } on AuthApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _emailError = error.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isVerifyingCode = false;
        });
      }
    }
  }

  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _codeFocusNodes[index + 1].requestFocus();
    }

    setState(() {});
  }

  KeyEventResult _onCodeKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _codeControllers[index].text.isEmpty &&
        index > 0) {
      _codeFocusNodes[index - 1].requestFocus();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  bool _isPasswordFormatValid(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Za-z]').hasMatch(password) &&
        RegExp(r'\d').hasMatch(password);
  }

  String _genderToApiValue(String gender) {
    if (gender == '남자') {
      return 'MALE';
    }

    return 'FEMALE';
  }

  Future<void> _handleSignUp() async {
    final String id = _idController.text.trim();

    setState(() {
      _idError = id.isEmpty ? '아이디를 입력해주세요.' : null;
      _passwordError = _isPasswordFormatValid(_passwordController.text)
          ? null
          : '비밀번호 형식이 잘못되었습니다.';
      _passwordConfirmError =
          _passwordController.text == _passwordConfirmController.text
          ? null
          : '비밀번호가 일치하지 않습니다.';
    });

    if (_idError != null ||
        _passwordError != null ||
        _passwordConfirmError != null) {
      return;
    }

    setState(() {
      _isSigningUp = true;
    });

    try {
      await authService.signUpWithApi(
        name: _nameController.text.trim(),
        id: id,
        email: _emailController.text.trim(),
        password: _passwordController.text,
        gender: _genderToApiValue(_selectedGender!),
        specialism: _selectedMajor!,
        generation: _selectedTerm!,
      );

      if (!mounted) {
        return;
      }

      debugPrint('회원가입 성공');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('회원가입이 완료되었습니다.')));

      Navigator.pop(context, _idController.text.trim());
    } on AuthApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _emailError = error.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSigningUp = false;
        });
      }
    }
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
          onTap: () {
            Navigator.pop(context);
          },
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
              const _FieldLabel('이름'),

              const SizedBox(height: 8),

              AppTextFormField(
                controller: _nameController,
                hintText: '이름을 입력해주세요',
              ),

              const SizedBox(height: 20),

              const _FieldLabel('아이디'),

              const SizedBox(height: 8),

              AppTextFormField(
                controller: _idController,
                hintText: '아이디를 입력해주세요',
                textInputAction: TextInputAction.next,
                errorText: _idError,
              ),

              const SizedBox(height: 20),

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
                      errorText: _emailError,
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
                    isLoading: _isSendingCode || _isVerifyingCode,
                    onSend: _handleSendCode,
                    onVerify: _handleVerifyCode,
                    isCodeFilled: _isCodeFilled,
                  ),
                ],
              ),

              if (_isCodeSent && !_isEmailVerified) ...[
                const SizedBox(height: 12),

                Row(
                  children: List.generate(6, (int index) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index < 5 ? 8 : 0),
                        child: Focus(
                          onKeyEvent: (_, KeyEvent event) {
                            return _onCodeKeyEvent(event, index);
                          },
                          child: TextFormField(
                            controller: _codeControllers[index],
                            focusNode: _codeFocusNodes[index],
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
                            onChanged: (String value) {
                              _onCodeChanged(value, index);
                            },
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
                    onTap: _isSendingCode ? null : _handleResendCode,
                    child: const Text('재전송', style: AppTextStyles.helperText),
                  ),
                ),
              ],

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

              const _FieldLabel('비밀번호'),

              const SizedBox(height: 8),

              AppTextFormField(
                controller: _passwordController,
                hintText: '비밀번호를 입력해주세요',
                obscureText: true,
                errorText: _passwordError,
              ),

              const SizedBox(height: 20),

              const _FieldLabel('비밀번호 확인'),

              const SizedBox(height: 8),

              AppTextFormField(
                controller: _passwordConfirmController,
                hintText: '비밀번호를 재입력해주세요',
                obscureText: true,
                errorText: _passwordConfirmError,
              ),

              const SizedBox(height: 20),

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
                items: _majors.map((String major) {
                  return DropdownMenuItem<String>(
                    value: major,
                    child: Text(major, style: AppTextStyles.fieldText),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedMajor = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              const _FieldLabel('성별'),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: AppSelectableButton(
                      text: '남자',
                      isSelected: _selectedGender == '남자',
                      width: double.infinity,
                      onTap: () {
                        setState(() {
                          _selectedGender = '남자';
                        });
                      },
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: AppSelectableButton(
                      text: '여자',
                      isSelected: _selectedGender == '여자',
                      width: double.infinity,
                      onTap: () {
                        setState(() {
                          _selectedGender = '여자';
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const _FieldLabel('기수'),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: _TermButton(
                      text: '8기',
                      isSelected: _selectedTerm == '8기',
                      onTap: () {
                        setState(() {
                          _selectedTerm = '8기';
                        });
                      },
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: _TermButton(
                      text: '9기',
                      isSelected: _selectedTerm == '9기',
                      onTap: () {
                        setState(() {
                          _selectedTerm = '9기';
                        });
                      },
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: _TermButton(
                      text: '10기',
                      isSelected: _selectedTerm == '10기',
                      onTap: () {
                        setState(() {
                          _selectedTerm = '10기';
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              AppButton(
                text: _isSigningUp ? '가입 중...' : '회원가입',
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

class _EmailActionButton extends StatelessWidget {
  const _EmailActionButton({
    required this.isVerified,
    required this.isCodeSent,
    required this.isLoading,
    required this.onSend,
    required this.onVerify,
    required this.isCodeFilled,
  });

  final bool isVerified;
  final bool isCodeSent;
  final bool isLoading;
  final VoidCallback onSend;
  final VoidCallback onVerify;
  final bool isCodeFilled;

  @override
  Widget build(BuildContext context) {
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

    if (isCodeSent) {
      return SizedBox(
        width: 88,
        height: 43,
        child: ElevatedButton(
          onPressed: isCodeFilled && !isLoading ? onVerify : null,
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
            isLoading ? '확인중' : '확인',
            style: AppTextStyles.disabledButtonText.copyWith(
              color: isCodeFilled && !isLoading ? Colors.white : null,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 88,
      height: 43,
      child: OutlinedButton(
        onPressed: isLoading ? null : onSend,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.mainColor,
          side: const BorderSide(color: AppColors.mainColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          isLoading ? '전송중' : '인증하기',
          style: AppTextStyles.outlineButtonText,
        ),
      ),
    );
  }
}

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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.fieldLabel);
  }
}
