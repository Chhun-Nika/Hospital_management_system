import 'dart:convert';
import 'dart:io';
import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/patient.dart';

class PatientRepository {
  final String filePath;

  PatientRepository(this.filePath);

  Map<String, Patient> readAll() {
    final file = File(filePath);

    if (!file.existsSync()) {
      throw FileSystemException('File not Found: $filePath');
    }

    final content = file.readAsStringSync();
    final data = jsonDecode(content) as List<dynamic>;

    final Map<String, Patient> patients = {};

    for (var pat in data) {
      final patientId = pat['patientId'] as String;
      final gender = Gender.values.firstWhere((g) => g.name == pat['gender']);

      final appointmentIds =
          (pat['appointmentIds'] as List<dynamic>?)
              ?.map((id) => id as String)
              .toList() ??
          [];

      patients[patientId] = Patient(
        patientId: patientId,
        fullName: pat['fullName'],
        gender: gender,
        dateOfBirth: DateTime.parse(pat['dateOfBirth']),
        phoneNumber: pat['phoneNumber'],
        address: pat['address'],
        emergencyContact: pat['emergencyContact'],
        appointmentIds: appointmentIds,
      );
    }
    return patients;
  }

  void writeAll(Map<String, Patient> patients) {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw FileSystemException('File not found: $filePath');
    }

    final data = patients.values.map((patient) {
      return {
        "patientId": patient.patientId,
        "fullName": patient.fullName,
        "gender": patient.gender.name,
        "dateOfBirth": patient.dateOfBirth.toIso8601String(),
        "phoneNumber": patient.phoneNumber,
        "address": patient.address,
        "emergencyContact": patient.emergencyContact,
        "appointmentIds": patient.appointmentIds,
      };
    }).toList();
    final encoder = JsonEncoder.withIndent(' ');
    final jsonString = encoder.convert(data);

    file.writeAsStringSync(jsonString);
  }
}
