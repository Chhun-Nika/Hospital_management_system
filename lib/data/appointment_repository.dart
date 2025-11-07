import 'dart:convert';
import 'dart:io';
import 'package:hospital_management_system/domain/appointment.dart';
import 'package:hospital_management_system/domain/enums.dart';
import 'package:intl/intl.dart';

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
      // final receptionistId = app['receptionistId'] as String;

      final appointmentStatus = AppointmentStatus.values.firstWhere(
        (s) => s.name == app['appointmentStatus'],
      );

      appointments[appointmentId] = Appointment(
        id: appointmentId,
        patientId: patientId,
        doctorId: doctorId,
        duration: app['duration'],
        reasons: app['reason'],
        dateTime: DateTime.parse(app['appointmentDateTime'] as String),
        appointmentStatus: appointmentStatus,
        doctorNotes: app['doctorNotes'],
      );
    }
    return appointments;
  }

  void writeAll (Map<String, Appointment> appointment) {
    final file = File(filePath);
     if (!file.existsSync()) {
      throw FileSystemException('File not found: $filePath');
    }
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');


    final data = appointment.values.map((apptm) => {
      'appointmentId': apptm.appointmentId,
      'patientId': apptm.patientId,
      'doctorId': apptm.doctorId,
      'appointmentDateTime': formatter.format(apptm.appointmentDateTime),
      'duration': apptm.duration,
      'reason' : apptm.reason,
      'appointmentStatus': apptm.appointmentStatus.name,
      'doctorNotes': null
    }).toList();

    final encoder = JsonEncoder.withIndent(' ');
    final jsonString = encoder.convert(data);

    file.writeAsStringSync(jsonString);
  }
}
