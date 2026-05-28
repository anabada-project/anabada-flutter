import 'package:flutter/material.dart';

class NoticeTile extends StatelessWidget {
  final String title;
  final String content;
  final String time;

  const NoticeTile({
    super.key,
    required this.title,
    required this.content,
    this.time = '1일 전',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,

      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEFF0F2), width: 1)),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(top: 18),

            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFEFF0F2), width: 1),
            ),

            child: const Icon(
              Icons.campaign,
              size: 18,
              color: Color(0xFF333333),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    content,

                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    time,

                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
