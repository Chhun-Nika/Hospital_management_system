import 'dart:collection';
import 'package:hospital_management_system/domain/appointment.dart';
import 'package:hospital_management_system/domain/doctor.dart';
import 'package:hospital_management_system/domain/nurse.dart';
import 'package:hospital_management_system/domain/patient.dart';

class Hospital {
  final Map<String, Doctor> _doctors = {};
  final Map<String, Nurse> _nurses = {};
  final Map<String, Appointment> _appointments = {};
  final Map<String, Patient> _patients = {};

  // as the getter returns map, and it will returns its reference,
  // so set it unmodifiable to avoid accidentally update from the instances of the this class
  // using unmodifiableMapView, uses the existing map for view yet using Map.unmodifiable copy the current Map and create new one
  Map<String, Doctor> get doctors => UnmodifiableMapView(_doctors);
  Map<String, Nurse> get nurses => UnmodifiableMapView(_nurses);
  Map<String, Appointment> get appointments =>
      UnmodifiableMapView(_appointments);
  Map<String, Patient> get patients => UnmodifiableMapView(_patients);

  // this function is use to add all doctors from json to current object
  void addDoctors(Map<String, Doctor> doctors) {
    _doctors.addAll(doctors);
  }

  void addPatients(Map<String, Patient> patients) {
    _patients.addAll(patients);
  }

  void addAppointment(Map<String, Appointment> appointments) {
    _appointments.addAll(appointments);
  }

  // for accessing and selecting each doctors via number instead of id
  List<MapEntry<String, Doctor>> getDoctorEntries() {
    return _doctors.entries.toList();
  }

   List<MapEntry<String, Patient>> getPatientEntries() {
    return _patients.entries.toList();
  }
}
