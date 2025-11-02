import 'package:hospital_management_system/domain/appointment.dart';
import 'package:hospital_management_system/domain/doctor.dart';
import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/patient.dart';
import 'package:hospital_management_system/domain/staff.dart';
import 'package:hospital_management_system/domain/time_slot.dart';

class Receptionist extends Staff {
  final List<String> _patientIds;
  final List<String> _appointmentIds;
  final Map<DayOfWeek, List<TimeSlot>> _workingSchedule;

  Receptionist({
    String? id,
    required super.name,
    required super.gender,
    required super.phoneNumber,
    required super.email,
    Map<DayOfWeek, List<TimeSlot>>? workingSchedule,
  }) : _workingSchedule = workingSchedule ?? {},
       _patientIds = [],
       _appointmentIds = [],
       super(role: Role.receptionist, staffId: id);

  List<String> get patientIds => _patientIds;
  List<String> get appointmentIds => _appointmentIds;
  Map<DayOfWeek, List<TimeSlot>> get workingSchedule => _workingSchedule;

  // create patient
  Patient createPatient({
    required String fullName,
    required Gender gender,
    required DateTime dateOfBirth,
    required String phoneNumber,
    required String address,
    required String emergencyContact,
    required String status,
  }) {
    return Patient(
      fullName: fullName,
      gender: gender,
      dateOfBirth: dateOfBirth,
      phoneNumber: phoneNumber,
      address: address,
      emergencyContact: emergencyContact,
      status: status,
    );
  }

  Appointment createAppointment({
    required String patientId,
    required String doctorId,
    required DateTime appointmentDateTime,
    int? duration,
    String? reason,
    AppointmentStatus? appointmentStatus,
    String? doctorNotes,
  }) {
    return Appointment(
      patientId: patientId,
      doctorId: doctorId,
      dateTime: appointmentDateTime,
      duration: duration,
      reasons: reason,
      appointmentStatus: appointmentStatus ?? AppointmentStatus.scheduled,
      doctorNotes: doctorNotes,
    );
  }
}
