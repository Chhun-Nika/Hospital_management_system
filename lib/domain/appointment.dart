import 'package:hospital_management_system/domain/enums.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Appointment {
  final String _appointmentId;
  final String _patientId;
  final String _doctorId;
  final DateTime _appointmentDateTime;
  final int _duration;
  final String? _reason;
  AppointmentStatus _appointmentStatus;
  String? _doctorNotes;

  Appointment({
    String? id,
    required String patientId,
    required String doctorId,
    required DateTime dateTime,
    int? duration,
    String? reasons,
  }) : _appointmentId = id ?? uuid.v4(),
       _patientId = patientId,
       _doctorId = doctorId,
       _appointmentDateTime = dateTime,
       _duration = duration ?? 2,
       _reason = reasons,
       // every new appoinment that is created will set to 'schedule'
       _appointmentStatus = AppointmentStatus.scheduled;


}
