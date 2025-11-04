import 'dart:convert';
import 'dart:io';
import 'package:hospital_management_system/domain/doctor.dart';
import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/time_slot.dart';

class DoctorRepository {
  final String filePath;

  DoctorRepository(this.filePath);

  Map<String, Doctor> readAll() {
    final file = File(filePath);

    if (!file.existsSync()) {
      throw FileSystemException('File not found: $filePath');
    }

    final contents = file.readAsStringSync();
    final data = jsonDecode(contents) as List<dynamic>;

    final Map<String, Doctor> doctors = {};

    for (var doc in data) {
      final staffId = doc['staffId'] as String;

      // - AI helps with converting these data - not AI generated
      // converting the working schedule
      // using 'as' casting, the value is not null
      final workingScheduleRaw = doc['workingSchedule'];
      final workingScheduleData = workingScheduleRaw != null
          ? workingScheduleRaw as Map<String, dynamic>
          : {};
      final Map<DayOfWeek, List<TimeSlot>> workingSchedule = {};

      workingScheduleData.forEach((day, slots) {
        // final dataSlots = slots as List<dynamic>;
        final timeSlotList = (slots as List<dynamic>)
            .map(
              (slot) =>
                  TimeSlot(startTime: slot['start'], endTime: slot['end']),
            )
            .toList();
        // set day to DayOfWeek type by using firstWhere
        workingSchedule[DayOfWeek.values.firstWhere((d) => d.name == day)] =
            timeSlotList;
      });

      // converting book slot
      final bookedSlotsRaw = doc['bookedSlots'];
      final bookedSlotsData = bookedSlotsRaw != null
          ? bookedSlotsRaw as Map<String, dynamic>
          : {};
      final Map<DateTime, List<TimeSlot>> bookedSlots = {};
      bookedSlotsData.forEach((date, slots) {
        final timeSlotsList = (slots as List<dynamic>)
            .map(
              (slot) =>
                  TimeSlot(startTime: slot['start'], endTime: slot['end']),
            )
            .toList();
        bookedSlots[DateTime.parse(date)] = timeSlotsList;
      });

      // converting gender
      final gender = Gender.values.firstWhere((g) => g.name == doc['gender']);

      doctors[staffId] = Doctor(
        id: doc['staffId'],
        name: doc['name'],
        gender: gender,
        phoneNumber: doc['phoneNumber'],
        email: doc['email'],
        specialization: doc['specialization'],
        workingSchedule: workingSchedule,
        bookedSlots: bookedSlots
      );
    }
    return doctors;
  }
}
