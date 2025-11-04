import 'package:hospital_management_system/domain/enums.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Appointment {
  final String _appointmentId;
  final String _patientId;
  final String _doctorId;
  final String _receptionistId;
  final DateTime _appointmentDateTime;
  final int _duration;
  final String? _reason;
  AppointmentStatus _appointmentStatus;
  String? _doctorNotes;

  Appointment({
    String? id,
    required String patientId,
    required String doctorId,
    required String receptionistId,
    required DateTime dateTime,
    int? duration,
    String? reasons,
    required AppointmentStatus appointmentStatus,
    String? doctorNotes, 
  }) : _appointmentId = id ?? uuid.v4(),
       _patientId = patientId,
       _doctorId = doctorId,
       _receptionistId = receptionistId,
       _appointmentDateTime = dateTime,
       _duration = duration ?? 2,
       _reason = reasons,
       // every new appoinment that is created will set to 'schedule'
       _appointmentStatus = AppointmentStatus.scheduled,
       _doctorNotes = doctorNotes;

  String get appointmentId => _appointmentId;
  String get patientId => _patientId;
  String get doctorId => _doctorId;
  String get recepionistId => _receptionistId;
  DateTime get appointmentDateTime => _appointmentDateTime;
  int get duration => _duration;
  String? get reason => _reason;
  AppointmentStatus get appointmentStatus => _appointmentStatus;
  String? get doctorNotes => _doctorNotes;
}
