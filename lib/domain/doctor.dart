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
    required super.phoneNumber,
    required super.email,
    required String specialization,
    required Map<DayOfWeek, List<TimeSlot>>? workingSchedule,
    Map<DateTime, List<TimeSlot>>? bookedSlots,
  }) : _specialization = specialization,
       _workingSchedule = workingSchedule ?? {},
       _bookedSlots = bookedSlots ?? {},
       _appointmentIds = [],
       super(staffId: id, role: Role.doctor);


  String get specialization => _specialization;
  Map<DayOfWeek, List<TimeSlot>> get workingSchedule => _workingSchedule;

  DateTime _dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  // Check if doctor works at that time
  bool isWorkingAt(DateTime appointmentDateTime, int durationMinutes) {
    final day = DayOfWeek.values[appointmentDateTime.weekday - 1];
    final slots = workingSchedule[day];
    if (slots == null) return false;

    final appointmentEnd = appointmentDateTime.add(Duration(minutes: durationMinutes));

    return slots.any((slot) {
      final startParts = slot.startTime.split(':').map(int.parse).toList();
      final endParts = slot.endTime.split(':').map(int.parse).toList();

      final slotStart = DateTime(
        appointmentDateTime.year,
        appointmentDateTime.month,
        appointmentDateTime.day,
        startParts[0],
        startParts[1],
      );
      final slotEnd = DateTime(
        appointmentDateTime.year,
        appointmentDateTime.month,
        appointmentDateTime.day,
        endParts[0],
        endParts[1],
      );

      return appointmentDateTime.isAfter(slotStart) &&
            appointmentEnd.isBefore(slotEnd);
    });
 }


  // Check if appointment overlaps with existing booked slots
  bool hasConflict(DateTime appointmentDateTime, int durationMinutes) {
    final appointmentEnd = appointmentDateTime.add(
      Duration(minutes: durationMinutes),
    );
    final dayKey = _dateOnly(appointmentDateTime);
    final bookedSlotForDay = _bookedSlots[dayKey] ?? [];

    return bookedSlotForDay.any((slot) {
      final slotStart = DateTime(
        dayKey.year,
        dayKey.month,
        dayKey.day,
        int.parse(slot.startTime.split(':')[0]),
        int.parse(slot.startTime.split(':')[1]),
      );
      final slotEnd = DateTime(
        dayKey.year,
        dayKey.month,
        dayKey.day,
        int.parse(slot.endTime.split(':')[0]),
        int.parse(slot.endTime.split(':')[1]),
      );
      return appointmentDateTime.isBefore(slotEnd) ||
          appointmentEnd.isAfter(slotStart);
    });
  }

  // Book a slot (after appointment confirmed)
 void bookSlot(DateTime appointmentDateTime, int durationMinutes) {
  final dayKey = _dateOnly(appointmentDateTime);

  // Format to "HH:mm"
  final start = "${appointmentDateTime.hour.toString().padLeft(2, '0')}:${appointmentDateTime.minute.toString().padLeft(2, '0')}";
  final endTime = appointmentDateTime.add(Duration(minutes: durationMinutes));
  final end = "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}";

  final newSlot = TimeSlot(startTime: start, endTime: end);

  _bookedSlots.putIfAbsent(dayKey, () => []);
  _bookedSlots[dayKey]!.add(newSlot);
}

// for updates
void updateInformation ({String? name, Gender? gender, String? email, String? phoneNumber, String? specialization}) {
  if (name != null) this.name = name;
}

// format working schedule
String formatWorkingSchedule () {
  final formatted = workingSchedule.entries.map((entry) {
    final day = entry.key.name;
    final time = entry.value.map((t) => "${t.startTime} - ${t.endTime}");
    return "$day : $time";
  }).join('\n');

  return formatted;
}


}
