import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/staff.dart';
import 'package:hospital_management_system/domain/time_slot.dart';

class Nurse extends Staff {
  String _doctorId;
  final Map<DayOfWeek, List<TimeSlot>> _workingSchedule;

  // using named constructor in order to make the constructor private so it cannot be instantiated outside the class and other subclass 
  Nurse({
    required super.name,
    required super.gender,
    required super.phoneNumber,
    required super.email,
    required String doctorId,
    Map<DayOfWeek, List<TimeSlot>>? workingSchedule,
  }) : _doctorId = doctorId,
       _workingSchedule = workingSchedule ?? {},
       super(role: Role.nurse);

  String get doctorId => _doctorId;
  Map<DayOfWeek, List<TimeSlot>> get workingSchedule => _workingSchedule;

  
}
