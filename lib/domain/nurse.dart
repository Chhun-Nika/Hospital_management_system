import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/staff.dart';
import 'package:hospital_management_system/domain/time_slot.dart';

class Nurse extends Staff {
  String _doctorId;
  final Map<DayOfWeek, List<TimeSlot>> _workingSchedule;

  Nurse({
    String? id,
    required super.name,
    required String role,
    required super.phoneNumber,
    required super.email,
    required String doctorId,
    Map<DayOfWeek, List<TimeSlot>>? workingSchedule,
  }) : _doctorId = doctorId,
       _workingSchedule = workingSchedule ?? {},
       super(staffId: id, role: Role.nurse);

  String get doctorId => _doctorId;
  Map<DayOfWeek, List<TimeSlot>> get workingSchedule => _workingSchedule;

  
}
