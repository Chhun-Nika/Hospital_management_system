import 'package:hospital_management_system/domain/appointment.dart';
import 'package:hospital_management_system/domain/doctor.dart';
import 'package:hospital_management_system/domain/nurse.dart';
import 'package:hospital_management_system/domain/patient.dart';

class Hospital {
  final List<Doctor> _doctors = [];
  final List<Nurse> _nurses = [];
  final List<Appointment> _appointments = [];
  final List<Patient> _patients = [];

}