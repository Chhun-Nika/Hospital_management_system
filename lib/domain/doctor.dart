import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/staff.dart';
import 'package:hospital_management_system/domain/time_of_day.dart';
import 'package:hospital_management_system/domain/time_slot.dart';

class Doctor extends Staff {
  String _specialization;
  final List<String> _appointmentIds;
  // store the time or slots that has been booked - avoid overlapping appointment dateTime
  Map<DateTime, List<TimeSlot>> _bookedSlots;

  // using super to call
  Doctor({
    String? id,
    required super.name,
    required super.gender,
    required super.phoneNumber,
    required super.email,
    required String specialization,
    required super.workingSchedule,
    Map<DateTime, List<TimeSlot>>? bookedSlots,
  }) : _specialization = specialization,
       _bookedSlots = bookedSlots ?? {},
       _appointmentIds = [],
       super(staffId: id, role: Role.doctor);

  String get specialization => _specialization;

  DateTime _dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  List<String> get appointmentIds => _appointmentIds;

  Map<DateTime, List<TimeSlot>> get bookedSlots => _bookedSlots;

  // Check if doctor works at that time
  //   bool isWorkingAt(DateTime appointmentDateTime, int durationMinutes) {
  //     final day = DayOfWeek.values[appointmentDateTime.weekday - 1];
  //     final slots = workingSchedule[day];
  //     if (slots == null) return false;

  //     final appointmentEnd = appointmentDateTime.add(Duration(minutes: durationMinutes));

  //     return slots.any((slot) {
  //       final startParts = slot.startTime.split(':').map(int.parse).toList();
  //       final endParts = slot.endTime.split(':').map(int.parse).toList();

  //       final slotStart = DateTime(
  //         appointmentDateTime.year,
  //         appointmentDateTime.month,
  //         appointmentDateTime.day,
  //         startParts[0],
  //         startParts[1],
  //       );
  //       final slotEnd = DateTime(
  //         appointmentDateTime.year,
  //         appointmentDateTime.month,
  //         appointmentDateTime.day,
  //         endParts[0],
  //         endParts[1],
  //       );

  //       return appointmentDateTime.isAfter(slotStart) &&
  //             appointmentEnd.isBefore(slotEnd);
  //     });
  //  }
  bool isWorkingAt(DateTime appointmentDateTime, int durationMinutes) {
    final day = DayOfWeek.values[appointmentDateTime.weekday - 1];
    final slots = workingSchedule[day];
    if (slots == null) return false;

    final appointmentStart = TimeOfDay(
      hour: appointmentDateTime.hour,
      minute: appointmentDateTime.minute,
    );
    final appointmentEndTime = appointmentDateTime.add(
      Duration(minutes: durationMinutes),
    );
    final appointmentEnd = TimeOfDay(
      hour: appointmentEndTime.hour,
      minute: appointmentEndTime.minute,
    );

    // return slots.any(
    //   (slot) =>
    //       appointmentStart.isAfter(slot.startTime) &&
    //       appointmentEnd.isBefore(slot.endTime),
    // );
    return slots.any((slot) {
    // start >= slot.startTime && end <= slot.endTime
    final startsOnOrAfter = appointmentStart.isAfter(slot.startTime) || 
    (appointmentStart.hour == slot.startTime.hour && appointmentStart.minute == slot.startTime.minute);
    final endsOnOrBefore = appointmentEnd.isBefore(slot.endTime) || 
   (appointmentEnd.hour == slot.endTime.hour && appointmentEnd.minute == slot.endTime.minute);
    return startsOnOrAfter && endsOnOrBefore;
  });
  }

  // Check if appointment overlaps with existing booked slots
  // bool hasConflict(DateTime appointmentDateTime, int durationMinutes) {
  //   final appointmentEnd = appointmentDateTime.add(
  //     Duration(minutes: durationMinutes),
  //   );
  //   final dayKey = _dateOnly(appointmentDateTime);
  //   final bookedSlotForDay = _bookedSlots[dayKey] ?? [];

  //   return bookedSlotForDay.any((slot) {
  //     final slotStart = DateTime(
  //       dayKey.year,
  //       dayKey.month,
  //       dayKey.day,
  //       int.parse(slot.startTime.split(':')[0]),
  //       int.parse(slot.startTime.split(':')[1]),
  //     );
  //     final slotEnd = DateTime(
  //       dayKey.year,
  //       dayKey.month,
  //       dayKey.day,
  //       int.parse(slot.endTime.split(':')[0]),
  //       int.parse(slot.endTime.split(':')[1]),
  //     );
  //     return appointmentDateTime.isBefore(slotEnd) ||
  //         appointmentEnd.isAfter(slotStart);
  //   });
  // }
  bool hasConflict(DateTime appointmentDateTime, int durationMinutes) {
    final appointmentStart = TimeOfDay(
      hour: appointmentDateTime.hour,
      minute: appointmentDateTime.minute,
    );
    final appointmentEndTime = appointmentDateTime.add(
      Duration(minutes: durationMinutes),
    );
    final appointmentEnd = TimeOfDay(
      hour: appointmentEndTime.hour,
      minute: appointmentEndTime.minute,
    );

    final dayKey = _dateOnly(appointmentDateTime);
    final bookedSlotsForDay = _bookedSlots[dayKey] ?? [];

    return bookedSlotsForDay.any(
      (slot) =>
          appointmentStart.isBefore(slot.endTime) &&
          appointmentEnd.isAfter(slot.startTime),
    );
  }

  // Book a slot (after appointment confirmed)
  // void bookSlot(DateTime appointmentDateTime, int durationMinutes) {
  //   final dayKey = _dateOnly(appointmentDateTime);

  //   // Format to "HH:mm"
  //   final start =
  //       "${appointmentDateTime.hour.toString().padLeft(2, '0')}:${appointmentDateTime.minute.toString().padLeft(2, '0')}";
  //   final endTime = appointmentDateTime.add(Duration(minutes: durationMinutes));
  //   final end =
  //       "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}";

  //   final newSlot = TimeSlot(startTime: start, endTime: end);

  //   _bookedSlots.putIfAbsent(dayKey, () => []);
  //   _bookedSlots[dayKey]!.add(newSlot);
  // }
  void bookSlot(DateTime appointmentDateTime, int durationMinutes) {
    final dayKey = _dateOnly(appointmentDateTime);

    final startTime = TimeOfDay(
      hour: appointmentDateTime.hour,
      minute: appointmentDateTime.minute,
    );
    final endTimeDate = appointmentDateTime.add(
      Duration(minutes: durationMinutes),
    );
    final endTime = TimeOfDay(
      hour: endTimeDate.hour,
      minute: endTimeDate.minute,
    );

    final newSlot = TimeSlot(startTime: startTime, endTime: endTime);

    _bookedSlots.putIfAbsent(dayKey, () => []);
    _bookedSlots[dayKey]!.add(newSlot);
  }

  // for updates
  // void updateInformation({
  //   String? name,
  //   Gender? gender,
  //   String? email,
  //   String? phoneNumber,
  //   String? specialization,
  // }) {
  //   if (name != null) this.name = name;
  // }

  

  // update specialization
  String? updateSpecialization (String newSpecialization) {
    if(newSpecialization == _specialization) return "New specialization is the same as current specialization";
    _specialization = newSpecialization;
    return null;
  }

  void removeBookedSlot(DateTime dateTime, int durationMinutes) {
    final dayKey = _dateOnly(dateTime);
    final slots = _bookedSlots[dayKey];
    if (slots == null) return;

    final appointmentStart = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    final appointmentEndTime = dateTime.add(Duration(minutes: durationMinutes));
    final appointmentEnd = TimeOfDay(hour: appointmentEndTime.hour, minute: appointmentEndTime.minute);

    // Remove the slot that exactly matches this appointment
    _bookedSlots[dayKey] = slots.where((slot) {
      final isDifferent =
          slot.startTime.isBefore(appointmentStart) || slot.endTime.isAfter(appointmentEnd);
      return isDifferent;
    }).toList();
  }




}
