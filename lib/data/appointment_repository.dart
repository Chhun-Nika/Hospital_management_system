import 'dart:convert';
import 'dart:io';
import 'package:hospital_management_system/domain/appointment.dart';
import 'package:hospital_management_system/domain/enums.dart';

class AppointmentRepository {
  final String filePath;

  AppointmentRepository(this.filePath);

  Map<String, Appointment> readAll() {
    final file = File(filePath);

    if (!file.existsSync()) {
      throw FileSystemException('File not found: $filePath');
    }

    final contents = file.readAsStringSync();
    final data = jsonDecode(contents) as List<dynamic>;

    final Map<String, Appointment> appointments = {};

    for (var app in data) {
      final appointmentId = app['appointmentId'] as String;
      final patientId = app['patientId'] as String;
      final doctorId = app['doctorId'] as String;
      final receptionistId = app['receptionistId'] as String;

      final appointmentStatus = AppointmentStatus.values.firstWhere(
        (s) => s.name == app['appointmentStatus'],
      );

      appointments[appointmentId] = Appointment(
        id: appointmentId,
        patientId: patientId,
        doctorId: doctorId,
        receptionistId: receptionistId,
        duration: app['duration'],
        reasons: app['reason'],
        dateTime: DateTime.parse(app['appointmentDateTime'] as String),
        appointmentStatus: appointmentStatus,
      );
    }
    return appointments;
  }
}
