import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/time_slot.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

abstract class Staff {
  final String _staffId;
  String name;
  Gender gender;
  Role _role;
  String _phoneNumber;
  String _email;
  Map<DayOfWeek, List<TimeSlot>> workingSchedule;

  Staff({
    String? staffId,
    required this.name,
    required this.gender,
    required Role role,
    required String phoneNumber,
    required String email,
    required this.workingSchedule,
  }) : _staffId = staffId ?? uuid.v4(),
       _role = role,
       _phoneNumber = _validatePhoneNumber(phoneNumber),
       _email = _validateEmail(email);

  String get staffId => _staffId;
  Role get role => _role;
  String get phoneNumber => _phoneNumber;
  String get email => _email;

  set phoneNumber(String value) {
    _phoneNumber = _validatePhoneNumber(value);
  }

  set email(String value) {
    _email = _validateEmail(value);
  }

  static String _validateEmail(String value) {
    if (!value.contains('@') || !value.contains('.')) {
      throw Exception('Invalid email format: $value');
    }
    return value;
  }

  static String _validatePhoneNumber(String value) {
    if (value.length < 9) {
      throw Exception('Invalid phone number: $value');
    }
    return value;
  }

  List<MapEntry<DayOfWeek, List<TimeSlot>>> getWorkingScheduleEntries() {
    return workingSchedule.entries.toList();
  }

  // handle working schedule management
  bool addShift(DayOfWeek day, TimeSlot newSlot) {
    // if the key exists it will return the list of slot
    // yet if not it will create a new key with the value of empty timeslot list
    workingSchedule[day] ??= [];

    // checking timeslot overlapping
    // .any will return false if the list is empty
    List<TimeSlot> slots = workingSchedule[day]!;
    bool overlap = slots.any((slot) => _isOverlapping(slot, newSlot));
    if (overlap) {
      return false;
    }

    workingSchedule[day]!.add(newSlot);
    return true;
  }

  // bool _isOverlapping (TimeSlot existing, TimeSlot newSlot) {
  //   final existingStart = existing.startTime;
  //   final existingEnd = existing.endTime;
  //   final newStart = newSlot.startTime;
  //   final newEnd = newSlot.endTime;

  //   bool overlap = true;
  //   if (newStart.compareTo(existingEnd) < 0 && newEnd.compareTo(existingStart) > 0) {
  //     overlap = true;
  //   } else {
  //     overlap = false;
  //   }

  //   return overlap;

  // }
  bool _isOverlapping(TimeSlot existing, TimeSlot newSlot) {
    final existingStart = existing.startTime;
    final existingEnd = existing.endTime;
    final newStart = newSlot.startTime;
    final newEnd = newSlot.endTime;

    // Overlap exists if newStart < existingEnd && newEnd > existingStart
    return newStart.isBefore(existingEnd) && newEnd.isAfter(existingStart);
  }

  bool deleteShift(DayOfWeek day, TimeSlot slotToDelete) {
    if (!workingSchedule.containsKey(day)) {
      return false;
    }

    // To make this work, TimeSlot needs proper equality comparison
    return workingSchedule[day]!.remove(slotToDelete);
  }
}
