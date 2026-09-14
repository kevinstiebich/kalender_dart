import 'package:flutter/material.dart';
import 'package:kalender_dart/gui/calendar_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // nicht notwendig, Debug Banner wird in der finalen Version sowieso nicht angezeigt
      home: const CalendarPage(),
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.green)),
    );
  }
}
