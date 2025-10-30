import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/staff.dart';
import 'package:hospital_management_system/domain/time_slot.dart';

class Doctor extends Staff {
  String _specialization;
  List<String> _appointmentIds;
  Map<DayOfWeek, List<TimeSlot>> _workingSchedule;
  Map<DayOfWeek, List<TimeSlot>> _bookedSlots;

  // using super to call 
  Doctor({
    String? id,
    required super.name,
    required super.role,
    required super.phoneNumber,
    required super.email,
    required String specialization,
    Map<DayOfWeek, List<TimeSlot>>? workingSchedule,
    Map<DayOfWeek, List<TimeSlot>>? bookedSlots,
  }) : _specialization = specialization,
       _workingSchedule = workingSchedule ?? {},
       _bookedSlots = bookedSlots ?? {},
       _appointmentIds = [],
       super(staffId: id);
}
