import 'package:flutter/material.dart';
import 'package:kalender_dart/gui/calendar_area.dart';
import 'package:kalender_dart/helpers/wiki_function.dart';

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
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    List<Map<String, dynamic>> loadedEvents =
        await WikiFunctions.createRandomWikiEvent(
          displayedDate.day,
          displayedDate.month,
        );

    setState(() {
      events = loadedEvents;
    });
  }

  void _onPreviousMonth() {
    setState(() {
      displayedDate = DateTime(
        displayedDate.year,
        displayedDate.month - 1,
        displayedDate.day,
      );
    });
  }

  void _onNextMonth() {
    setState(() {
      displayedDate = DateTime(
        displayedDate.year,
        displayedDate.month + 1,
        displayedDate.day,
      );
    });
  }

  void _onChangeDay(int day) {
    setState(() {
      displayedDate = DateTime(displayedDate.year, displayedDate.month, day);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Build von CalendarPage');
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

        child: CalendarArea(
          displayedDate: displayedDate,
          events: events,
          onNextMonth: _onNextMonth,
          onPreviousMonth: _onPreviousMonth,
          onChangeDay: _onChangeDay,
        ),
      ),
    );
  }
}
