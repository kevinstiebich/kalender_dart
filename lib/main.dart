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

  // Funktion um den Kalender zu erstellen
  List<TableRow> createCalendar(int day, int month, int year) {
    int monthStart = DateTime(year, month, 1).weekday;
    int daysBeforeFirst = monthStart - 1;
    int runner = 1;
    int rowCount = ((daysBeforeFirst + getNumberOfDays(month, year)) / 7)
        .ceil();
    List<TableRow> rows = [];

    for (int i = 0; i <= rowCount; i++) {
      List<Widget> cells = [];

      for (int j = 0; j < 7; j++) {
        int cellIndex = i * 7 + j;

        if (cellIndex < daysBeforeFirst ||
            runner > getNumberOfDays(month, year)) {
          // Leere Zelle
          cells.add(const SizedBox());
        } else {
          int currentDay = runner;

          cells.add(
            GestureDetector(
              onTap: () {
                setState(() {
                  displayedDate = DateTime(year, month, currentDay);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Text("$currentDay", textAlign: TextAlign.center),
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

  void previousMonth() {
    setState(() {
      displayedDate = DateTime(
        displayedDate.year,
        displayedDate.month - 1,
        displayedDate.day,
      );
    });
  }

  void nextMonth() {
    setState(() {
      displayedDate = DateTime(
        displayedDate.year,
        displayedDate.month + 1,
        displayedDate.day,
      );
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
              "Jahres ${displayedDate.year}. Es handelt sich um den ${calcDayOfTheYear(displayedDate.day, displayedDate.month, displayedDate.year)}. Tag des Jahres, was bedeutet, dass es noch "
              "${calcDaysRemaining(displayedDate.day, displayedDate.month, displayedDate.year)} Tage bis zum Jahresende sind. Der Monat ${getMonthName(displayedDate.month)} hat insgesamt ${getNumberOfDays(displayedDate.month, displayedDate.year)} Tage. Heute ist "
              "${isHoliday(displayedDate.day, displayedDate.month, displayedDate.year)} gesetzlicher Feiertag in Deutschland.",
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

            Table(
              border: TableBorder.all(),
              children: [
                TableRow(
                  children: [
                    Text("Mo", textAlign: TextAlign.center),
                    Text("Di", textAlign: TextAlign.center),
                    Text("Mi", textAlign: TextAlign.center),
                    Text("Do", textAlign: TextAlign.center),
                    Text("Fr", textAlign: TextAlign.center),
                    Text("Sa", textAlign: TextAlign.center),
                    Text("So", textAlign: TextAlign.center),
                  ],
                ),
                ...createCalendar(
                  displayedDate.day,
                  displayedDate.month,
                  displayedDate.year,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ################################## CREATORS ##################################

// ################################## GETTER ##################################

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

int getNumberOfDays(int month, int year) {
  List<int> numberOfDays = [
    31,
    isLeapYear(year) ? 29 : 28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31,
  ];
  return numberOfDays[month - 1];
}

// ################################## CALCULATORS ##################################

int calcDayOfTheYear(int day, int month, int year) {
  for (int i = 1; i < month; i++) {
    day += getNumberOfDays(i, year);
  }
  return day;
}

//rechnet aus wieviele Tage dieses Jahr noch hat
int calcDaysRemaining(int day, int month, int year) {
  int remaining;
  if (isLeapYear(year)) {
    remaining = 366;
  } else {
    remaining = 365;
  }
  return remaining -= calcDayOfTheYear(day, month, year);
}

List<int> calcEaster(int year) {
  var a = year % 19;
  var b = (year / 100).floor();
  var c = year % 100;
  var d = (b / 4).floor();
  var e = b % 4;
  var f = ((b + 8) / 25).floor();
  var g = ((b - f + 1) / 3).floor();
  var h = (19 * a + b - d - g + 15) % 30;
  var i = (c / 4).floor();
  var k = c % 4;
  var l = (32 + 2 * e + 2 * i - h - k) % 7;
  var m = ((a + 11 * h + 22 * l) / 451).floor();

  var month = ((h + l - 7 * m + 114) / 31).floor();
  var day = ((h + l - 7 * m + 114) % 31) + 1;

  var easterMonthDay = [month, day];
  return easterMonthDay;
}

List<int> calcHolidays(int addend, int year) {
  var holiday = calcEaster(year);
  holiday[1] += addend;
  if (addend > 0) {
    while (holiday[1] > getNumberOfDays(holiday[0], year)) {
      holiday[1] -= getNumberOfDays(holiday[0], year);
      holiday[0]++;
    }
  } else {
    while (holiday[1] < 1) {
      holiday[0]--;
      holiday[1] += getNumberOfDays(holiday[0], year);
    }
  }
  return holiday;
}

// ################################## HELPER ##################################

bool isLeapYear(int year) {
  if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
    return true;
  } else {
    return false;
  }
}

String isHoliday(int day, int month, int year) {
  var easter = calcEaster(year);
  var goodFriday = calcHolidays(-2, year);
  var easterMonday = calcHolidays(1, year);
  var ascensionOfChrist = calcHolidays(40, year);
  var whitMonday = calcHolidays(51, year);
  var corpusChristi = calcHolidays(60, year);

  var holidays = [
    [1, 1],
    [easter[1], easter[0]],
    [goodFriday[1], goodFriday[0]],
    [easterMonday[1], easterMonday[0]],
    [ascensionOfChrist[1], ascensionOfChrist[0]],
    [whitMonday[1], whitMonday[0]],
    [corpusChristi[1], corpusChristi[0]],
    [3, 10],
    [25, 12],
    [26, 12],
  ];

  for (int i = 0; i < holidays.length; i++) {
    if (day == holidays[i][0] && month == holidays[i][1]) {
      return "ein";
    }
  }

  return "kein";
}
