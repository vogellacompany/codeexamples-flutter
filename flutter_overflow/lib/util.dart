import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';

/// Converts a Unix Timestamp since epoch in seconds to [DateTime]
DateTime creationDateFromJson(int date) {
  return DateTime.fromMillisecondsSinceEpoch(date * 1000);
}

final HtmlUnescape htmlUnescape = HtmlUnescape();

/// Unescapes HTML in a string
String unescapeHtml(String source) {
  var convert = htmlUnescape.convert(source);
  return convert;
}

/// Formats a [DateTime]
///
/// If the supplied [DateTime]
/// - is on the same day as [DateTime.now()], return "today at HH:mm" = "today at 19:39"
/// - is yesterday relative to [DateTime.now()] return "yesterday at HH:mm" = "yesterday at 19:39"
/// - is in the current year return "MMM dd at HH:mm" = "Nov 11 at 19:39"
/// - "MMM dd yyyy at HH:mm" = "Nov 11 2018 at 19:39"
String formatDate(DateTime date) {
  var now = DateTime.now();
  if (date.year == now.year) {
    if (date.month == now.month) {
      if (date.day == now.day) {
        return 'today at ' + DateFormat('HH:mm').format(date);
      } else if (date.day == now.day - 1) {
        return 'yesterday at ' + DateFormat('HH:mm').format(date);
      }
    }
    // Using ' to escape the "at" portion of the output
    return DateFormat("MMM dd 'a't HH:mm").format(date);
  } else {
    return DateFormat("MMM dd yyyy 'a't HH:mm").format(date);
  }
}
