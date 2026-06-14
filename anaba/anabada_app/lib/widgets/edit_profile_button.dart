import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../pages/edit_profile_page.dart';

class EditProfileButton extends StatelessWidget {
  final String name;
  final String email;
  final String major;
  final String generation;
  final ValueChanged<EditProfileResult> onProfileUpdated;

  const EditProfileButton({
    super.key,
    required this.name,
    required this.email,
    required this.major,
    required this.generation,
    required this.onProfileUpdated,
  });

  Future<void> _openEditProfilePage(BuildContext context) async {
    final EditProfileResult? result = await Navigator.push<EditProfileResult>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          initialName: name,
          initialEmail: email,
          initialMajor: major,
          initialGeneration: generation,
        ),
      ),
    );

    if (result == null) {
      return;
    }

    onProfileUpdated(result);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: OutlinedButton(
        onPressed: () {
          _openEditProfilePage(context);
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.mainColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text('정보 수정', style: AppTextStyles.editButton),
      ),
    );
  }
}
