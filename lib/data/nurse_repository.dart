import 'dart:convert';
import 'dart:io';
import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/nurse.dart';
import 'package:hospital_management_system/domain/time_of_day.dart';
import 'package:hospital_management_system/domain/time_slot.dart';

class NurseRepository {
  final String filePath;

  NurseRepository(this.filePath);

  Map<String, Nurse> readAll() {
    final file = File(filePath);

    if (!file.existsSync()) {
      throw FileSystemException('File not found: $filePath');
    }

    final contents = file.readAsStringSync();
    if (contents.trim().isEmpty) {
      throw Exception("File is empty: $filePath");
    }
    final data = jsonDecode(contents) as List<dynamic>;

    final Map<String, Nurse> nurses = {};

    for (var nurse in data) {
      final staffId = nurse['staffId'] as String;

      // - AI helps with converting these data - not AI generated
      // converting the working schedule
      // using 'as' casting, the value is not null
      final workingScheduleRaw = nurse['workingSchedule'];
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

      // converting gender
      final gender = Gender.values.firstWhere((g) => g.name == nurse['gender']);

      nurses[staffId] = Nurse(
        id: nurse['staffId'],
        name: nurse['name'],
        gender: gender,
        phoneNumber: nurse['phoneNumber'],
        email: nurse['email'],
        doctorId: nurse['doctorId'],
        workingSchedule: workingSchedule,
      );
    }
    return nurses;
  }

  void writeAll(Map<String, Nurse> nurses) {
    final file = File(filePath);

    final data = nurses.values.map((nurse) {
      // convert the working schedule
      final Map<String, List<Map<String, String>>> workingScheduleToJson = {};
      nurse.workingSchedule.forEach((day, slots) {
        workingScheduleToJson[day.name] = slots
            .map(
              (slot) => {
                'start': slot.startTime.format(),
                'end': slot.endTime.format(),
              },
            )
            .toList();
      });
      return {
        'staffId': nurse.staffId,
        'name': nurse.name,
        'gender': nurse.gender.name,
        'role': 'Nurse',
        'phoneNumber': nurse.phoneNumber,
        'email': nurse.email,
        'doctorId': nurse.doctorId,
        'workingSchedule': workingScheduleToJson,
      };
    }).toList();
    final encoder = JsonEncoder.withIndent(' ');
    final jsonString = encoder.convert(data);

    file.writeAsStringSync(jsonString);
  }
}
