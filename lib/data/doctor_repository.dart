import 'dart:convert';
import 'dart:io';
import 'package:hospital_management_system/domain/doctor.dart';
import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/time_of_day.dart';
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
    if (contents.trim().isEmpty) {
      throw Exception("File is empty: $filePath");
    }
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
        final timeSlotList = (slots as List<dynamic>).map((slot) {
          final startParts = (slot['start'] as String).split(':');
          final endParts = (slot['end'] as String).split(':');
          final startTime = TimeOfDay(
            hour: int.parse(startParts[0]),
            minute: int.parse(startParts[1]),
          );
          final endTime = TimeOfDay(
            hour: int.parse(endParts[0]),
            minute: int.parse(endParts[1]),
          );

          return TimeSlot(startTime: startTime, endTime: endTime);
        }).toList();
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
        final timeSlotsList = (slots as List<dynamic>).map((slot) {
          final startParts = (slot['start'] as String).split(':');
          final endParts = (slot['end'] as String).split(':');
          final startTime = TimeOfDay(
            hour: int.parse(startParts[0]),
            minute: int.parse(startParts[1]),
          );
          final endTime = TimeOfDay(
            hour: int.parse(endParts[0]),
            minute: int.parse(endParts[1]),
          );

          return TimeSlot(startTime: startTime, endTime: endTime);
        }).toList();
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
        bookedSlots: bookedSlots,
      );
    }
    return doctors;
  }

  void writeAll(Map<String, Doctor> doctors) {
    final file = File(filePath);

    final data = doctors.values.map((doctor) {
      // convert the working schedule
      final Map<String, List<Map<String, String>>> workingScheduleToJson = {};
      doctor.workingSchedule.forEach((day, slots) {
        workingScheduleToJson[day.name] = slots
            .map(
              (slot) => {
                'start': slot.startTime.format(),
                'end': slot.endTime.format(),
              },
            )
            .toList();
      });
      // booked slot
      final Map<String, List<Map<String, String>>> bookedSlotToJson = {};
      doctor.bookedSlots.forEach((date, slots) {
        bookedSlotToJson[date.toIso8601String().split('T')[0]] = slots
            .map(
              (slot) => {
                'start': slot.startTime.format(),
                'end': slot.endTime.format(),
              },
            )
            .toList();
      });
      return {
        'staffId': doctor.staffId,
        'name': doctor.name,
        'gender': doctor.gender.name,
        'role': 'Doctor',
        'phoneNumber': doctor.phoneNumber,
        'email': doctor.email,
        'specialization': doctor.specialization,
        // 'appointmentIds': doctor.appointmentIds,
        'workingSchedule': workingScheduleToJson,
        'bookedSlots': bookedSlotToJson,
      };
    }).toList();
    final encoder = JsonEncoder.withIndent(' ');
    final jsonString = encoder.convert(data);

    file.writeAsStringSync(jsonString);
  }
}
