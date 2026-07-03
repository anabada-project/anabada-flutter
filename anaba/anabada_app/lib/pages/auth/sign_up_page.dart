import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/auth_api_service.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/auth/sign_up_widgets.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_selectable_button.dart';
import '../../widgets/common/app_text_form_field.dart';

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

  final List<_Option> _majorOptions = const [
    _Option(label: '백엔드', value: 'BACKEND'),
    _Option(label: '프론트엔드', value: 'FRONTEND'),
    _Option(label: '디자인', value: 'DESIGN'),
    _Option(label: '플러터', value: 'FLUTTER'),
    _Option(label: 'iOS', value: 'IOS'),
    _Option(label: '안드로이드', value: 'ANDROID'),
    _Option(label: '기획', value: 'PM'),
    _Option(label: 'AI', value: 'AI'),
  ];

  final List<_Option> _genderOptions = const [
    _Option(label: '남자', value: 'MALE'),
    _Option(label: '여자', value: 'FEMALE'),
  ];

  final List<_Option> _termOptions = const [
    _Option(label: '8기', value: '8기'),
    _Option(label: '9기', value: '9기'),
    _Option(label: '10기', value: '10기'),
  ];

  String? _selectedMajor;
  String? _selectedGender;
  String? _selectedTerm;

  bool _isCodeSent = false;
  bool _isEmailVerified = false;
  bool _isEmailActionLoading = false;
  bool _isSubmitting = false;

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
        !_isEmailActionLoading &&
        !_isSubmitting;
  }

  bool get _isCodeFilled =>
      _codeControllers.every((c) => c.text.isNotEmpty) &&
      !_isEmailActionLoading;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_refresh);
    _idController.addListener(_handleIdChanged);
    _emailController.addListener(_handleEmailChanged);
    _passwordController.addListener(_handlePasswordChanged);
    _passwordConfirmController.addListener(_handlePasswordConfirmChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();

    for (final TextEditingController controller in _codeControllers) {
      controller.dispose();
    }

    for (final FocusNode focusNode in _codeFocusNodes) {
      focusNode.dispose();
    }

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
      _isEmailActionLoading = false;
      _emailError = null;

      for (final TextEditingController controller in _codeControllers) {
        controller.clear();
      }
    });
  }

  void _handlePasswordChanged() {
    if (!mounted) {
      return;
    }

    setState(() {
      _passwordError = null;
      _passwordConfirmError = null;
    });
  }

  void _handlePasswordConfirmChanged() {
    if (!mounted) {
      return;
    }

    setState(() {
      _passwordConfirmError = null;
    });
  }

  void _handleSendCode() {
    _sendCode();
  }

  void _handleResendCode() {
    _sendCode(clearCurrentCode: true);
  }

  Future<void> _sendCode({bool clearCurrentCode = false}) async {
    if (_isEmailActionLoading) {
      return;
    }

    final String email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _emailError = '이메일을 입력해주세요.';
      });
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _emailError = null;
      _isEmailActionLoading = true;
    });

    try {
      final AuthApiMessageResult result = await authService
          .requestSignUpEmailCodeWithApi(email: email);

      if (!mounted) {
        return;
      }

      if (clearCurrentCode) {
        for (final TextEditingController controller in _codeControllers) {
          controller.clear();
        }
      }

      setState(() {
        _emailError = null;
        _isCodeSent = true;
        _isEmailVerified = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));

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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint('회원가입 인증번호 발송 실패: $error');

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
          _isEmailActionLoading = false;
        });
      }
    }
  }

  void _handleVerifyCode() {
    _verifyCode();
  }

  Future<void> _verifyCode() async {
    if (_isEmailActionLoading) {
      return;
    }

    final String code = _codeControllers.map((controller) {
      return controller.text;
    }).join();

    setState(() {
      _emailError = null;
      _isEmailActionLoading = true;
    });

    try {
      final AuthApiMessageResult result = await authService
          .verifySignUpEmailCodeWithApi(
            email: _emailController.text,
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
      ).showSnackBar(SnackBar(content: Text(result.message)));
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

      debugPrint('회원가입 이메일 인증 실패: $error');

      const String message = '이메일 인증에 실패했습니다. 잠시 후 다시 시도해주세요.';
      setState(() {
        _emailError = message;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _isEmailActionLoading = false;
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

  Future<void> _handleSignUp() async {
    final String id = _idController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    setState(() {
      _idError = id.isEmpty ? '아이디를 입력해주세요.' : null;
      _emailError = _isEmailVerified ? null : '이메일 인증을 완료해주세요.';
      _passwordError = _isPasswordFormatValid(password)
          ? null
          : '비밀번호는 영문과 숫자를 포함해 8자 이상이어야 합니다.';
      _passwordConfirmError = password == _passwordConfirmController.text
          ? null
          : '비밀번호가 일치하지 않습니다.';
    });

    if (_idError != null ||
        _emailError != null ||
        _passwordError != null ||
        _passwordConfirmError != null ||
        _selectedMajor == null ||
        _selectedGender == null ||
        _selectedTerm == null) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final AuthApiSignUpResult result = await authService.signUpWithApi(
        name: _nameController.text,
        id: id,
        email: email,
        password: password,
        specialism: _selectedMajor!,
        gender: _selectedGender!,
        generation: _selectedTerm!,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));

      Navigator.pop(context, id);
    } on AuthApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        if (error.statusCode == 401) {
          _emailError = error.message;
          _isEmailVerified = false;
        } else if (error.statusCode == 409) {
          _idError = error.message;
        } else {
          _emailError = error.message;
        }
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (_) {
      if (!mounted) {
        return;
      }

      const String message = '회원가입에 실패했습니다. 잠시 후 다시 시도해주세요.';
      setState(() {
        _emailError = message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
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
              const AuthFieldLabel('이름'),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _nameController,
                hintText: '이름을 입력해주세요',
              ),
              const SizedBox(height: 20),
              const AuthFieldLabel('아이디'),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _idController,
                hintText: '아이디를 입력해주세요',
                errorText: _idError,
              ),
              const SizedBox(height: 20),
              const AuthFieldLabel('이메일'),
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
                      enabled:
                          !_isEmailVerified &&
                          !_isCodeSent &&
                          !_isEmailActionLoading,
                      fillColor: (_isEmailVerified || _isCodeSent)
                          ? const Color(0xFFF6F7F8)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  EmailVerificationButton(
                    isVerified: _isEmailVerified,
                    isCodeSent: _isCodeSent,
                    onSend: _handleSendCode,
                    onVerify: _handleVerifyCode,
                    isCodeFilled: _isCodeFilled,
                  ),
                ],
              ),
              if (_isCodeSent && !_isEmailVerified) ...[
                const SizedBox(height: 12),
                Row(
                  children: List.generate(6, (i) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: i < 5 ? 8 : 0),
                        child: Focus(
                          onKeyEvent: (_, event) => _onCodeKeyEvent(event, i),
                          child: TextFormField(
                            controller: _codeControllers[i],
                            focusNode: _codeFocusNodes[i],
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
                            onChanged: (v) => _onCodeChanged(v, i),
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
                    onTap: _isEmailActionLoading ? null : _handleResendCode,
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
              const AuthFieldLabel('비밀번호'),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _passwordController,
                hintText: '비밀번호를 입력해주세요',
                obscureText: true,
                errorText: _passwordError,
              ),
              const SizedBox(height: 20),
              const AuthFieldLabel('비밀번호 확인'),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _passwordConfirmController,
                hintText: '비밀번호를 재입력해주세요',
                obscureText: true,
                errorText: _passwordConfirmError,
              ),
              const SizedBox(height: 20),
              const AuthFieldLabel('전공'),
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
                items: _majorOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option.value,
                    child: Text(option.label, style: AppTextStyles.fieldText),
                  );
                }).toList(),
                onChanged: _isSubmitting
                    ? null
                    : (value) => setState(() => _selectedMajor = value),
              ),
              const SizedBox(height: 20),
              const AuthFieldLabel('성별'),
              const SizedBox(height: 8),
              Row(
                children: _genderOptions.map((option) {
                  final int index = _genderOptions.indexOf(option);
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index == _genderOptions.length - 1 ? 0 : 8,
                      ),
                      child: AppSelectableButton(
                        text: option.label,
                        isSelected: _selectedGender == option.value,
                        width: double.infinity,
                        onTap: () {
                          setState(() {
                            _selectedGender = option.value;
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const AuthFieldLabel('기수'),
              const SizedBox(height: 8),
              Row(
                children: _termOptions.map((option) {
                  final int index = _termOptions.indexOf(option);
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index == _termOptions.length - 1 ? 0 : 8,
                      ),
                      child: SignUpTermButton(
                        text: option.label,
                        isSelected: _selectedTerm == option.value,
                        onTap: () {
                          setState(() {
                            _selectedTerm = option.value;
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              AppButton(
                text: _isSubmitting ? '가입 중...' : '회원가입',
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

class _Option {
  const _Option({required this.label, required this.value});

  final String label;
  final String value;
}
