import 'package:intl/intl.dart';

class Convert {
  static dynamic month(DateTime tm) {
    switch (tm.month) {
      case 1:
        return "Jan";

      case 2:
        return "Feb";

      case 3:
        return "Mar";

      case 4:
        return "Apr";

      case 5:
        return "May";

      case 6:
        return "Jun";

      case 7:
        return "Jul";

      case 8:
        return "Aug";

      case 9:
        return "Sep";

      case 10:
        return "Oct";

      case 11:
        return "Nov";

      case 12:
        return "Dec";
    }
  }

  static dynamic day(DateTime td) {
    var tempDay = DateFormat('EEEE').format(td);
    switch (tempDay) {
      case 'Monday':
        return "MON";

      case 'Tuesday':
        return "TUE";

      case 'Wednesday':
        return "WED";

      case 'Thursday':
        return "THU";

      case 'Friday':
        return "FRI";

      case 'Saturday':
        return "SAT";

      case 'Sunday':
        return "SUN";
    }
  }
}
