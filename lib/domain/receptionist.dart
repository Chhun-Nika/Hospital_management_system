import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/staff.dart';
import 'package:hospital_management_system/domain/time_slot.dart';

class Receptionist extends Staff {
  final List<String> _patientIds;
  final List<String> _appointmentIds;
  final Map<DateTime, List<TimeSlot>> _workingSchedule;

  Receptionist({
    String? id,
    required super.name,
    required String role,
    required super.phoneNumber,
    required super.email,
    Map<DateTime, List<TimeSlot>>? workingSchedule,
  }) : _workingSchedule = workingSchedule ?? {},
       _patientIds = [],
       _appointmentIds = [],
       super(staffId: id, role: Role.receptionist);

  List<String> get patientIds => _patientIds;
  List<String> get appointmentIds => _appointmentIds;
  Map<DateTime, List<TimeSlot>> get workingSchedule => _workingSchedule;
}
