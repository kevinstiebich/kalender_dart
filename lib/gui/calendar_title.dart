import 'package:flutter/material.dart';
import 'package:kalender_dart/helpers/date_functions.dart';

class CalendarTitle extends StatelessWidget {
  const CalendarTitle({
    super.key,
    required this.displayedDate,
  });

  final DateTime displayedDate;

  @override
  Widget build(BuildContext context) {
    print('Build von CalendarTitle');
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8F8F8), Color(0xFFE8E8E8)],
        ),

        border: Border.all(color: const Color(0xFF4A4A4A), width: 3),

        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        "Der ${displayedDate.day}. ${DateFunctions.getMonthName(displayedDate.month)} ${displayedDate.year} ist ein ${DateFunctions.getWeekday(displayedDate.weekday)} und zwar "
        "der ${DateFunctions.getNumberOfWeekdays(displayedDate.day)} ${DateFunctions.getWeekday(displayedDate.weekday)} im Monat ${DateFunctions.getMonthName(displayedDate.month)} des "
        "Jahres ${displayedDate.year}. Es handelt sich um den ${DateFunctions.calcDayOfTheYear(displayedDate.day, displayedDate.month, displayedDate.year)}. Tag des Jahres, was "
        "bedeutet, dass es noch ${DateFunctions.calcDaysRemaining(displayedDate.day, displayedDate.month, displayedDate.year)} Tage bis zum Jahresende sind. Der Monat ${DateFunctions.getMonthName(displayedDate.month)} "
        "hat insgesamt ${DateFunctions.getNumberOfDays(displayedDate.month, displayedDate.year)} Tage. Heute ist "
        "${DateFunctions.isHoliday(displayedDate.day, displayedDate.month, displayedDate.year)} gesetzlicher Feiertag in Deutschland.",
      ),
    );
  }
}
