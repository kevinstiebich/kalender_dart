abstract class DateFunctions {
  static int calcDayOfTheYear(int day, int month, int year) {
    for (int i = 1; i < month; i++) {
      day += getNumberOfDays(i, year);
    }
    return day;
  }

  //rechnet aus wieviele Tage dieses Jahr noch hat
  static int calcDaysRemaining(int day, int month, int year) {
    int remaining;
    if (isLeapYear(year)) {
      remaining = 366;
    } else {
      remaining = 365;
    }
    return remaining -= calcDayOfTheYear(day, month, year);
  }

  // ################################## CALCULATORS ##################################

  static List<int> calcEaster(int year) {
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

  static List<int> calcHolidays(int addend, int year) {
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

  static String getMonthName(int month) {
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

  static int getNumberOfDays(int month, int year) {
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

  static String getNumberOfWeekdays(int day) {
    const numberOfWeekdays = ["erste", "zweite", "dritte", "vierte", "fünfte"];

    if (day % 7 == 0) {
      return numberOfWeekdays[((day / 7) - 1).floor()];
    } else {
      return numberOfWeekdays[(day / 7).floor()];
    }
  }

  static String getWeekday(int weekday) {
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

  static String isHoliday(int day, int month, int year) {
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

  // ################################## HELPER ##################################

  static bool isLeapYear(int year) {
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
      return true;
    } else {
      return false;
    }
  }
}
