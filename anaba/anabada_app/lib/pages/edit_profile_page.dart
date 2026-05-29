import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _majorController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: '이승준');
    _emailController = TextEditingController(text: 's26000@gsm.hs.kr');
    _majorController = TextEditingController(text: '플러터');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _majorController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),

              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        '정보 수정',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 34),

              _label('이름'),
              const SizedBox(height: 10),
              _inputBox(_nameController),

              const SizedBox(height: 30),

              _label('이메일'),
              const SizedBox(height: 10),
              _inputBox(_emailController, enabled: false),

              const SizedBox(height: 30),

              _label('전공'),
              const SizedBox(height: 10),
              _inputBox(_majorController),

              const SizedBox(height: 30),

              _label('기수'),
              const SizedBox(height: 12),

              Row(
                children: [
                  _generationButton('8기', false),
                  const SizedBox(width: 12),
                  _generationButton('9기', false),
                  const SizedBox(width: 12),
                  _generationButton('10기', true),
                ],
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: const Text(
                    '저장하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  Widget _inputBox(TextEditingController controller, {bool enabled = true}) {
    return TextField(
      enabled: enabled,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: enabled ? Colors.white : const Color(0xFFF4F4F4),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDADADA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDADADA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.mainColor),
        ),
      ),
    );
  }

  Widget _generationButton(String text, bool selected) {
    return Expanded(
      child: SizedBox(
        height: 48,
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            backgroundColor: selected ? AppColors.mainColor : Colors.white,
            side: const BorderSide(color: AppColors.mainColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.mainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
