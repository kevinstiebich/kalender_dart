import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime displayedDate = DateTime.now();

  void previousMonth() {
    setState(() {
      displayedDate = DateTime(displayedDate.year, displayedDate.month - 1);
    });
  }

  void nextMonth() {
    setState(() {
      displayedDate = DateTime(displayedDate.year, displayedDate.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kalenderblatt vom ${displayedDate.day.toString().padLeft(2, "0")}.${displayedDate.month.toString().padLeft(2, "0")}.${displayedDate.year}",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Der ${displayedDate.day}. ${getMonthName(displayedDate.month)} ${displayedDate.year} ist ein ${getWeekday(displayedDate.weekday)} und zwar der ${getNumberOfWeekdays(displayedDate.day)} ${getWeekday(displayedDate.weekday)} im Monat ${getMonthName(displayedDate.month)} des "
              "Jahres ${displayedDate.year}. Es handelt sich um den 164. Tag des Jahres, was bedeutet, dass es noch "
              "201 Tage bis zum Jahresende sind. Der Monat Juni hat insgesamt 30 Tage. Heute ist "
              "kein gesetzlicher Feiertag in Deutschland.",
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: previousMonth,
                  icon: const Icon(Icons.arrow_back),
                ),

                Text("${displayedDate.month}.${displayedDate.year}"),

                IconButton(
                  onPressed: nextMonth,
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String getMonthName(int month) {
  const monthNames = [
    "Januar",
    "Februar",
    "März",
    "April",
    "Mai",
    "Juni",
    "Juli",
    "August",
    "September",
    "Oktober",
    "November",
    "Dezember",
  ];

  return monthNames[month - 1];
}

String getWeekday(int weekday) {
  const weekdays = [
    "Montag",
    "Dienstag",
    "Mittwoch",
    "Donnerstag",
    "Freitag",
    "Samstag",
    "Sonntag",
  ];

  return weekdays[weekday - 1];
}

String getNumberOfWeekdays(int day) {
  const numberOfWeekdays = ["erste", "zweite", "dritte", "vierte", "fünfte"];

  if (day % 7 == 0) {
    return numberOfWeekdays[((day / 7) - 1).floor()];
  } else {
    return numberOfWeekdays[(day / 7).floor()];
  }
}
