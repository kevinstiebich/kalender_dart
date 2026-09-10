import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

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

  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    List<Map<String, dynamic>> loadedEvents = await createRandomWikiEvent(
      displayedDate.day,
      displayedDate.month,
    );

    setState(() {
      events = loadedEvents;
    });
  }

  // Funktion um den Kalender zu erstellen
  List<TableRow> createCalendar(int day, int month, int year) {
    int monthStart = DateTime(year, month, 1).weekday;
    int daysBeforeFirst = monthStart - 1;
    int runner = 1;
    int rowCount = ((daysBeforeFirst + getNumberOfDays(month, year)) / 7)
        .ceil();
    List<TableRow> rows = [];

    for (int i = 0; i < rowCount; i++) {
      List<Widget> cells = [];

      for (int j = 0; j < 7; j++) {
        int cellIndex = i * 7 + j;

        if (cellIndex < daysBeforeFirst ||
            runner > getNumberOfDays(month, year)) {
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
          if (isHoliday(currentDay, month, year) == "ein") {
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
                setState(() {
                  displayedDate = DateTime(year, month, currentDay);
                });
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
        title: Center(
          child: Stack(
            children: [
              Text(
                "KaLéNderbLatt",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Pokemon",
                  fontSize: 35,
                  letterSpacing: 2,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 6
                    ..color = const Color(0xFF3C5AA6),
                ),
              ),

              const Text(
                "KaLéNderbLatt",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Pokemon",
                  fontSize: 35,
                  letterSpacing: 2,
                  color: Color(0xFFFFCB05),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pokemonworld.jpg"),
            fit: BoxFit.cover,
          ),
        ),

        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
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
                  "Der ${displayedDate.day}. ${getMonthName(displayedDate.month)} ${displayedDate.year} ist ein ${getWeekday(displayedDate.weekday)} und zwar der ${getNumberOfWeekdays(displayedDate.day)} ${getWeekday(displayedDate.weekday)} im Monat ${getMonthName(displayedDate.month)} des "
                  "Jahres ${displayedDate.year}. Es handelt sich um den ${calcDayOfTheYear(displayedDate.day, displayedDate.month, displayedDate.year)}. Tag des Jahres, was bedeutet, dass es noch "
                  "${calcDaysRemaining(displayedDate.day, displayedDate.month, displayedDate.year)} Tage bis zum Jahresende sind. Der Monat ${getMonthName(displayedDate.month)} hat insgesamt ${getNumberOfDays(displayedDate.month, displayedDate.year)} Tage. Heute ist "
                  "${isHoliday(displayedDate.day, displayedDate.month, displayedDate.year)} gesetzlicher Feiertag in Deutschland.",
                ),
              ),

              Container(
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
                      onPressed: previousMonth,
                      icon: const Icon(Icons.arrow_back),
                    ),

                    Text(
                      "${getMonthName(displayedDate.month)} ${displayedDate.year}",
                      style: const TextStyle(fontSize: 20),
                    ),

                    IconButton(
                      onPressed: nextMonth,
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),

              Table(
                /* border: TableBorder.all(), */
                children: [
                  TableRow(
                    children: [
                      calendarHeader("Mo"),
                      calendarHeader("Di"),
                      calendarHeader("Mi"),
                      calendarHeader("Do"),
                      calendarHeader("Fr"),
                      calendarHeader("Sa"),
                      calendarHeader("So"),
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
        ),
      ),
    );
  }
}

// ################################## CREATORS ##################################

Future<List<Map<String, dynamic>>> createRandomWikiEvent(
  int day,
  int month,
) async {
  String dayString = day.toString().padLeft(2, "0");
  String monthString = month.toString().padLeft(2, "0");
  String url =
      "https://api.wikimedia.org/feed/v1/wikipedia/de/onthisday/all/$monthString/$dayString";

  final response = await http.get(Uri.parse(url));
  final data = jsonDecode(response.body);

  List<int> random = createAndSortRandomNumbers(data["events"].length);
  List<Map<String, dynamic>> events = [];

  for (int i = 0; i < 5; i++) {
    events.add({
      "year": data["events"][random[i]]["year"],
      "event": data["events"][random[i]]["text"],
    });
  }

  return events;
}

Widget calendarHeader(String text) {
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
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}

List<int> createAndSortRandomNumbers(int size) {
  List<int> randomArray = [];

  for (int i = 0; i < 5; i++) {
    randomArray.add(Random().nextInt(size));
  }

  bool duplicate = true;

  while (duplicate) {
    duplicate = false;

    for (int i = 0; i < randomArray.length - 1; i++) {
      int temporary;
      for (int j = i; j < randomArray.length; j++) {
        if (randomArray[i] < randomArray[j]) {
          temporary = randomArray[i];
          randomArray[i] = randomArray[j];
          randomArray[j] = temporary;
        }
      }
    }

    for (int i = 0; i < randomArray.length - 1; i++) {
      if (randomArray[i] == randomArray[i + 1]) {
        randomArray[i + 1] = Random().nextInt(size);
        duplicate = true;
      }
    }
  }

  return randomArray;
}

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
