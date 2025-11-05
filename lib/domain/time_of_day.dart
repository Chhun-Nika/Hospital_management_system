class TimeOfDay {
  final int hour;
  final int minute;

  TimeOfDay({required this.hour, required this.minute});

  // Compare two times
  bool isBefore(TimeOfDay other) => hour < other.hour || (hour == other.hour && minute < other.minute);
  bool isAfter(TimeOfDay other) => hour > other.hour || (hour == other.hour && minute > other.minute);

  String format() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}