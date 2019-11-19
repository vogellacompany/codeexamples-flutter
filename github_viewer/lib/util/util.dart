String formatDate(DateTime date) {
  var diff = DateTime.now().difference(date);
  if (diff > Duration(days: 14)) {
    return '${(diff.inDays / 7).round()} weeks';
  } else if (diff > Duration(days: 7)) {
    return '${(diff.inDays / 7).round()} week';
  } else if (diff > Duration(hours: 48)) {
    return '${diff.inDays} days';
  } else if (diff > Duration(hours: 24)) {
    return '${diff.inDays} day';
  } else if (diff > Duration(minutes: 120)) {
    return '${diff.inHours} hours';
  } else if (diff > Duration(minutes: 60)) {
    return '${diff.inHours} hour';
  } else if (diff > Duration(minutes: 2)) {
    return '${diff.inMinutes} minutes';
  } else {
    return '1 minute';
  }
}
