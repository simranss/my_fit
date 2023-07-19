class DateTimeUtils {
  static String secondsToTime(int time) {
    int hour = (time / 60).floor();
    int rem = time % 60;
    int mins = (rem / 60).floor();
    return '${hour}h ${mins}m';
  }
}
