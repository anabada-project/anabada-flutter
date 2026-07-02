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

  final List<_Option> _majorOptions = const [
    _Option(label: '\uBC31\uC5D4\uB4DC', value: 'BACKEND'),
    _Option(label: '\uD504\uB860\uD2B8\uC5D4\uB4DC', value: 'FRONTEND'),
    _Option(label: '\uB514\uC790\uC778', value: 'DESIGN'),
    _Option(label: '\uD50C\uB7EC\uD130', value: 'FLUTTER'),
    _Option(label: 'iOS', value: 'IOS'),
    _Option(label: '\uC548\uB4DC\uB85C\uC774\uB4DC', value: 'ANDROID'),
    _Option(label: '\uAE30\uD68D', value: 'PM'),
    _Option(label: 'AI', value: 'AI'),
  ];

  final List<_Option> _genderOptions = const [
    _Option(label: '\uB0A8\uC790', value: 'MALE'),
    _Option(label: '\uC5EC\uC790', value: 'FEMALE'),
  ];

  final List<_Option> _termOptions = const [
    _Option(label: '8\uAE30', value: '8\uAE30'),
    _Option(label: '9\uAE30', value: '9\uAE30'),
    _Option(label: '10\uAE30', value: '10\uAE30'),
  ];

  String? _selectedMajor;
  String? _selectedGender;
  String? _selectedTerm;

  bool _isCodeSent = false;
  bool _isEmailVerified = false;
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
        !_isSubmitting;
  }

  bool get _isCodeFilled => _codeControllers.every((c) => c.text.isNotEmpty);

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
    final String email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _emailError =
            '\uC774\uBA54\uC77C\uC744 \uC785\uB825\uD574\uC8FC\uC138\uC694.';
      });
      return;
    }

    final String? code = authService.requestVerificationCode(
      email: email,
      purpose: EmailVerificationPurpose.signUp,
    );

    if (code == null) {
      setState(() {
        _emailError = authService.isEmailRegistered(email)
            ? '\uC774\uBBF8 \uAC00\uC785\uB41C \uC774\uBA54\uC77C\uC785\uB2C8\uB2E4.'
            : '\uC62C\uBC14\uB978 \uC774\uBA54\uC77C\uC744 \uC785\uB825\uD574\uC8FC\uC138\uC694.';
      });
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _emailError = null;
      _isCodeSent = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('\uD14C\uC2A4\uD2B8 \uC778\uC99D\uCF54\uB4DC: $code'),
      ),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _codeFocusNodes[0].requestFocus();
      }
    });
  }

  void _handleResendCode() {
    final String? code = authService.requestVerificationCode(
      email: _emailController.text,
      purpose: EmailVerificationPurpose.signUp,
    );

    for (final TextEditingController controller in _codeControllers) {
      controller.clear();
    }

    _codeFocusNodes[0].requestFocus();
    setState(() {});

    if (code != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('\uD14C\uC2A4\uD2B8 \uC778\uC99D\uCF54\uB4DC: $code'),
        ),
      );
    }
  }

  void _handleVerifyCode() {
    final String code = _codeControllers.map((controller) {
      return controller.text;
    }).join();

    if (!authService.verifyCode(email: _emailController.text, code: code)) {
      setState(() {
        _emailError =
            '\uC778\uC99D\uCF54\uB4DC\uAC00 \uC62C\uBC14\uB974\uC9C0 \uC54A\uC2B5\uB2C8\uB2E4.';
      });
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _emailError = null;
      _isEmailVerified = true;
      _isCodeSent = false;
    });
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
      _idError = id.isEmpty
          ? '\uC544\uC774\uB514\uB97C \uC785\uB825\uD574\uC8FC\uC138\uC694.'
          : null;
      _emailError = _isEmailVerified
          ? null
          : '\uC774\uBA54\uC77C \uC778\uC99D\uC744 \uC644\uB8CC\uD574\uC8FC\uC138\uC694.';
      _passwordError = _isPasswordFormatValid(password)
          ? null
          : '\uBE44\uBC00\uBC88\uD638\uB294 \uC601\uBB38\uACFC \uC22B\uC790\uB97C \uD3EC\uD568\uD574 8\uC790 \uC774\uC0C1\uC774\uC5B4\uC57C \uD569\uB2C8\uB2E4.';
      _passwordConfirmError = password == _passwordConfirmController.text
          ? null
          : '\uBE44\uBC00\uBC88\uD638\uAC00 \uC77C\uCE58\uD558\uC9C0 \uC54A\uC2B5\uB2C8\uB2E4.';
    });

    if (_idError != null ||
        _emailError != null ||
        _passwordError != null ||
        _passwordConfirmError != null) {
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

      const String message =
          '\uD68C\uC6D0\uAC00\uC785\uC5D0 \uC2E4\uD328\uD588\uC2B5\uB2C8\uB2E4. \uC7A0\uC2DC \uD6C4 \uB2E4\uC2DC \uC2DC\uB3C4\uD574\uC8FC\uC138\uC694.';
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
              Text('\uB4A4\uB85C\uAC00\uAE30', style: AppTextStyles.helperText),
            ],
          ),
        ),
        title: const Text(
          '\uD68C\uC6D0\uAC00\uC785',
          style: AppTextStyles.screenTitle,
        ),
        actions: const [SizedBox(width: 100)],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _FieldLabel('\uC774\uB984'),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _nameController,
                hintText:
                    '\uC774\uB984\uC744 \uC785\uB825\uD574\uC8FC\uC138\uC694',
              ),
              const SizedBox(height: 20),
              const _FieldLabel('\uC544\uC774\uB514'),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _idController,
                hintText:
                    '\uC544\uC774\uB514\uB97C \uC785\uB825\uD574\uC8FC\uC138\uC694',
                errorText: _idError,
              ),
              const SizedBox(height: 20),
              const _FieldLabel('\uC774\uBA54\uC77C'),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextFormField(
                      controller: _emailController,
                      hintText:
                          '\uC774\uBA54\uC77C\uC744 \uC785\uB825\uD574\uC8FC\uC138\uC694',
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
                    onTap: _handleResendCode,
                    child: const Text(
                      '\uC7AC\uC804\uC1A1',
                      style: AppTextStyles.helperText,
                    ),
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
                      '\uC774\uBA54\uC77C \uC778\uC99D\uC774 \uC644\uB8CC\uB418\uC5C8\uC2B5\uB2C8\uB2E4.',
                      style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              const _FieldLabel('\uBE44\uBC00\uBC88\uD638'),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _passwordController,
                hintText:
                    '\uBE44\uBC00\uBC88\uD638\uB97C \uC785\uB825\uD574\uC8FC\uC138\uC694',
                obscureText: true,
                errorText: _passwordError,
              ),
              const SizedBox(height: 20),
              const _FieldLabel('\uBE44\uBC00\uBC88\uD638 \uD655\uC778'),
              const SizedBox(height: 8),
              AppTextFormField(
                controller: _passwordConfirmController,
                hintText:
                    '\uBE44\uBC00\uBC88\uD638\uB97C \uC7AC\uC785\uB825\uD574\uC8FC\uC138\uC694',
                obscureText: true,
                errorText: _passwordConfirmError,
              ),
              const SizedBox(height: 20),
              const _FieldLabel('\uC804\uACF5'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedMajor,
                isExpanded: true,
                dropdownColor: Colors.white,
                menuMaxHeight: 360,
                hint: const Text(
                  '\uC804\uACF5\uC744 \uC120\uD0DD\uD574\uC8FC\uC138\uC694',
                  style: AppTextStyles.fieldHint,
                ),
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
              const _FieldLabel('\uC131\uBCC4'),
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
              const _FieldLabel('\uAE30\uC218'),
              const SizedBox(height: 8),
              Row(
                children: _termOptions.map((option) {
                  final int index = _termOptions.indexOf(option);
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index == _termOptions.length - 1 ? 0 : 8,
                      ),
                      child: _TermButton(
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
                text: _isSubmitting
                    ? '\uAC00\uC785 \uC911...'
                    : '\uD68C\uC6D0\uAC00\uC785',
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
    required this.onSend,
    required this.onVerify,
    required this.isCodeFilled,
  });

  final bool isVerified;
  final bool isCodeSent;
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
          child: const Text(
            '\uC778\uC99D\uC644\uB8CC',
            style: AppTextStyles.disabledButtonText,
          ),
        ),
      );
    }

    if (isCodeSent) {
      return SizedBox(
        width: 88,
        height: 43,
        child: ElevatedButton(
          onPressed: isCodeFilled ? onVerify : null,
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
            '\uD655\uC778',
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
        child: const Text(
          '\uC778\uC99D\uD558\uAE30',
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

class _Option {
  const _Option({required this.label, required this.value});

  final String label;
  final String value;
}
