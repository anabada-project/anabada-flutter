import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.userName,
    required this.email,
    required this.major,
    required this.generation,
  });

  final String userName;
  final String email;
  final String major;
  final String generation;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 106,
      padding: const EdgeInsets.symmetric(horizontal: 16),

      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEAEAEA)),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Row(
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xFFE4E4E4),
            child: Icon(Icons.person, size: 52, color: Colors.white),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(userName, style: AppTextStyles.profileName),

                const SizedBox(height: 8),

                Text(email, style: AppTextStyles.grayBody),

                const SizedBox(height: 4),

                Text(major, style: AppTextStyles.grayBody),
              ],
            ),
          ),

          Text(generation, style: AppTextStyles.grayBody),
        ],
      ),
    );
  }
}
