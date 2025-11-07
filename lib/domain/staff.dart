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

  // manage working schedule
  // turning map to list for easy display and access index since mostly user select by number not input the string
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

    final removed = workingSchedule[day]?.remove(slotToDelete) ?? false;
    if (workingSchedule[day]?.isEmpty ?? false) {
      workingSchedule.remove(day);
    }

    return removed;
  }

  // update staff information

  String? updateName(String newName) {
    // if (newName.trim().isEmpty) return "Name cannot be empty.";
    if (newName == name) return "New name is the same as current name.";
    name = newName;
    return null;
  }

  String? updateGender(Gender newGender) {
    if (newGender == gender) return "New gender is the same as current gender.";
    gender = newGender;
    return null;
  }

  String? updateEmail(String newEmail) {
    try {
      newEmail = _validateEmail(newEmail);
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }

    if (newEmail == _email) return "New email is the same as current email.";
    _email = newEmail;
    return null;
  }

  String? updatePhoneNumber(String newNumber) {
    try {
      newNumber = _validatePhoneNumber(newNumber);
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }

    if (newNumber == _phoneNumber) return "New phone number is the same as current number.";
    _phoneNumber = newNumber;
    return null;
  }

  // validation 
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

  String formatWorkingSchedule() {
    final formatted = workingSchedule.entries
        .map((entry) {
          final day = entry.key.name;
          final time = entry.value.map(
            (t) => "${t.startTime.format()} - ${t.endTime.format()}",
          );
          return "$day : $time";
        })
        .join('\n');

    return formatted;
  }


}
