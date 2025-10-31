import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/staff.dart';
import 'package:hospital_management_system/domain/time_slot.dart';

class Doctor extends Staff {
  final String _specialization;
  final List<String> _appointmentIds;
  // store the working schedule of each doctor based on day of the week
  final Map<DayOfWeek, List<TimeSlot>> _workingSchedule;
  // store the time or slots that has been booked - avoid overlapping appointment dateTime
  final Map<DateTime, List<TimeSlot>> _bookedSlots;

  // using super to call 
  Doctor({
    String? id,
    required super.name,
    required super.gender,
    required super.role,
    required super.phoneNumber,
    required super.email,
    required String specialization,
    Map<DayOfWeek, List<TimeSlot>>? workingSchedule,
    Map<DateTime, List<TimeSlot>>? bookedSlots,
  }) : _specialization = specialization,
       _workingSchedule = workingSchedule ?? {},
       _bookedSlots = bookedSlots ?? {},
       _appointmentIds = [],
       super(staffId: id);
}
