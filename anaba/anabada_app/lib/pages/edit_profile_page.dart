import 'package:flutter/material.dart';

import '../widgets/edit_profile_header.dart';
import '../widgets/edit_profile_input_field.dart';
import '../widgets/generation_button.dart';
import '../widgets/save_profile_button.dart';

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

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _majorController = TextEditingController();
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

              const EditProfileHeader(),

              const SizedBox(height: 34),

              EditProfileInputField(
                label: '이름',
                hintText: '이승준',
                controller: _nameController,
              ),

              const SizedBox(height: 30),

              EditProfileInputField(
                label: '이메일',
                hintText: 's26000@gsm.hs.kr',
                controller: _emailController,
                enabled: false,
              ),

              const SizedBox(height: 30),

              EditProfileInputField(
                label: '전공',
                hintText: '플러터',
                controller: _majorController,
              ),

              const SizedBox(height: 30),

              const Text(
                '기수',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              const Row(
                children: [
                  GenerationButton(text: '8기', selected: false),

                  SizedBox(width: 12),

                  GenerationButton(text: '9기', selected: false),

                  SizedBox(width: 12),

                  GenerationButton(text: '10기', selected: true),
                ],
              ),

              const Spacer(),

              const SaveProfileButton(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
