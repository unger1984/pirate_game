String formatTime(int timeInSecond) {
  int sec = timeInSecond % 60;
  int min = (timeInSecond / 60).floor();
  String minute = "$min".padLeft(2, '0');
  String second = "$sec".padLeft(2, '0');

  return "$minute:$second";
}
