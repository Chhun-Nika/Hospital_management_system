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
}
