import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

abstract class WikiFunctions {
  static Future<List<Map<String, dynamic>>> createRandomWikiEvent(
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

  static List<int> createAndSortRandomNumbers(int size) {
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
}
