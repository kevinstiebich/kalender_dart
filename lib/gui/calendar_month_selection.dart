import 'package:flutter/material.dart';
import 'package:kalender_dart/helpers/date_functions.dart';

class CalendarMonthSelection extends StatelessWidget {
  const CalendarMonthSelection({
    super.key,
    required this.onPreviousMonth,
    required this.displayedDate,
    required this.onNextMonth,
  });

  final Function() onPreviousMonth;
  final DateTime displayedDate;
  final Function() onNextMonth;

  @override
  Widget build(BuildContext context) {
    print('Build von CalendarMonthSelection');
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 255, 251, 234),
            Color.fromARGB(255, 255, 238, 182),
          ],
        ),

        border: Border.all(color: const Color(0xFF4A4A4A), width: 3),

        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onPreviousMonth,
            icon: const Icon(Icons.arrow_back),
          ),

          Text(
            "${DateFunctions.getMonthName(displayedDate.month)} ${displayedDate.year}",
            style: const TextStyle(fontSize: 20),
          ),

          IconButton(
            onPressed: onNextMonth,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
