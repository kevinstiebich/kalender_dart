import 'package:flutter/material.dart';
import 'package:kalender_dart/gui/calendar_month_selection.dart';
import 'package:kalender_dart/gui/calendar_table_header.dart';
import 'package:kalender_dart/gui/calendar_title.dart';
import 'package:kalender_dart/helpers/date_functions.dart';

class CalendarArea extends StatelessWidget {
  const CalendarArea({
    super.key,
    required this.displayedDate,
    required this.events,
    required this.onNextMonth,
    required this.onPreviousMonth,
    required this.onChangeDay,
  });

  final DateTime displayedDate;
  final List<Map<String, dynamic>> events;
  final Function() onNextMonth;
  final Function() onPreviousMonth;
  final Function(int day) onChangeDay;

  // Funktion um den Kalender zu erstellen
  List<TableRow> createCalendar(int day, int month, int year) {
    int monthStart = DateTime(year, month, 1).weekday;
    int daysBeforeFirst = monthStart - 1;
    int runner = 1;
    int rowCount =
        ((daysBeforeFirst + DateFunctions.getNumberOfDays(month, year)) / 7)
            .ceil();
    List<TableRow> rows = [];

    for (int i = 0; i < rowCount; i++) {
      List<Widget> cells = [];

      for (int j = 0; j < 7; j++) {
        int cellIndex = i * 7 + j;

        if (cellIndex < daysBeforeFirst ||
            runner > DateFunctions.getNumberOfDays(month, year)) {
          // Leere Zelle
          cells.add(
            Container(
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.symmetric(vertical: 12),

              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF4A4A4A), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "",
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        } else {
          int currentDay = runner;
          Color cellColor = Colors.white;

          // Farbe für Samstage
          if (j == 5) {
            cellColor = const Color.fromARGB(255, 197, 226, 255);
          }

          // Farbe für Sonntage
          if (j == 6) {
            cellColor = const Color.fromARGB(255, 255, 197, 197);
          }

          // Farbe für Feiertage
          if (DateFunctions.isHoliday(currentDay, month, year) == "ein") {
            cellColor = const Color.fromARGB(255, 125, 255, 125);
          }

          // Farbe für den ausgewählten Tag
          if (currentDay == displayedDate.day &&
              month == displayedDate.month &&
              year == displayedDate.year) {
            cellColor = const Color(0xFFFFCB05);
          }

          cells.add(
            GestureDetector(
              onTap: () {
                onChangeDay(currentDay);
              },
              child: Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.symmetric(vertical: 12),

                decoration: BoxDecoration(
                  color: cellColor,
                  border: Border.all(color: const Color(0xFF4A4A4A), width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "$currentDay",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );

          runner++;
        }
      }

      rows.add(TableRow(children: cells));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    print('Build von CalendarArea');
    return SingleChildScrollView(
      child: Column(
        children: [
          CalendarTitle(displayedDate: displayedDate),
          CalendarMonthSelection(
            onPreviousMonth: onPreviousMonth,
            displayedDate: displayedDate,
            onNextMonth: onNextMonth,
          ),

          Table(
            /* border: TableBorder.all(), */
            children: [
              TableRow(
                children: [
                  CalendarTableHeader(text: "Mo"),
                  CalendarTableHeader(text: "Di"),
                  CalendarTableHeader(text: "Mi"),
                  CalendarTableHeader(text: "Do"),
                  CalendarTableHeader(text: "Fr"),
                  CalendarTableHeader(text: "Sa"),
                  CalendarTableHeader(text: "So"),
                ],
              ),
              ...createCalendar(
                displayedDate.day,
                displayedDate.month,
                displayedDate.year,
              ),
            ],
          ),

          const SizedBox(height: 30),

          Container(
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF4A4A4A), width: 3),

              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              "Historische Ereignisse",
              style: TextStyle(fontSize: 20),
            ),
          ),

          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 197, 229, 255),
                  Color.fromARGB(255, 72, 173, 255),
                ],
              ),

              border: Border.all(color: const Color(0xFF4A4A4A), width: 3),

              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                if (events.isEmpty)
                  const Text("Ereignisse werden geladen...")
                else
                  for (int i = 0; i < events.length; i++)
                    Text("${events[i]["year"]}: ${events[i]["event"]}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
