import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/staff.dart';
import 'package:hospital_management_system/domain/time_slot.dart';

class Receptionist extends Staff {
  final List<String> _patientIds;
  final List<String> _appointmentIds;
  final Map<DayOfWeek, List<TimeSlot>> _workingSchedule;

  Receptionist({
    String? id,
    required super.name,
    required super.gender,
    required super.phoneNumber,
    required super.email,
    Map<DayOfWeek, List<TimeSlot>>? workingSchedule,
  }) : _workingSchedule = workingSchedule ?? {},
       _patientIds = [],
       _appointmentIds = [],
       super(role: Role.receptionist, staffId: id);

  List<String> get patientIds => _patientIds;
  List<String> get appointmentIds => _appointmentIds;
  Map<DayOfWeek, List<TimeSlot>> get workingSchedule => _workingSchedule;
}
