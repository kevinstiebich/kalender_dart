import 'package:flutter/material.dart';

class CalendarTableHeader extends StatelessWidget {
  const CalendarTableHeader({super.key, required this.text});

  final String text;

  Widget build(BuildContext context) {
    print('Build von CalendarTableHeader');
    return Container(
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.symmetric(vertical: 8),

      decoration: BoxDecoration(
        color: const Color(0xFF2A75BB),
        borderRadius: BorderRadius.circular(8),
      ),

      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
