import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/hospital.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Appointment {
  final String _appointmentId;
  final String _patientId;
  final String _doctorId;
  final DateTime _appointmentDateTime;
  int _duration;
  String? _reason;
  AppointmentStatus _appointmentStatus;
  String? _doctorNotes;

  Appointment({
    String? id,
    required String patientId,
    required String doctorId,
    required DateTime dateTime,
    int? duration,
    String? reasons,
    AppointmentStatus? appointmentStatus,
    String? doctorNotes,
  }) : _appointmentId = id ?? uuid.v4(),
       _patientId = patientId,
       _doctorId = doctorId,
       _appointmentDateTime = dateTime,
       _duration = duration ?? 2,
       _reason = reasons,
       // every new appoinment that is created will set to 'schedule'
       _appointmentStatus = appointmentStatus ?? AppointmentStatus.scheduled,
       _doctorNotes = doctorNotes;

  String get appointmentId => _appointmentId;
  String get patientId => _patientId;
  String get doctorId => _doctorId;
  DateTime get appointmentDateTime => _appointmentDateTime;
  int get duration => _duration;
  String? get reason => _reason;
  AppointmentStatus get appointmentStatus => _appointmentStatus;
  String? get doctorNotes => _doctorNotes;
  

  String? updateReason(String newReason) {
    if (newReason == _reason) {
      return "New Reason is the same as current reason.";
    }
    _reason = newReason;
    return null;
  }

  String? updateNote(String newNote) {
    if (newNote == _doctorNotes) {
      return "New Note is the same as current reason.";
    }
    _doctorNotes = newNote;
    return null;
  }

  String? updateDduration(int newDuration) {
    if (newDuration <= 0) {
      return "Duration cannot be nagetive.";
    }
    if (newDuration == _duration) {
      return "New Duration is the same as current duration.";
    }
    _duration = newDuration;
    return null;
  }

  String? updateStatus(AppointmentStatus newStatus, Hospital hospital) {
    if (appointmentStatus == newStatus) {
      return "Status is already ${newStatus.name}";
    }

    // If changing to cancel, remove booked slot from doctor
    if (appointmentStatus != AppointmentStatus.cancel &&
        newStatus == AppointmentStatus.cancel) {
      // Find the doctor in hospital's _doctors map
      final doctor = hospital.doctors[doctorId]; // or hospital.getAllDoctors()[doctorId] if it's a map
      if (doctor != null) {
        doctor.removeBookedSlot(appointmentDateTime, duration);
      }
    }

    _appointmentStatus = newStatus;
    return null; // status updated successfully
  }




}
