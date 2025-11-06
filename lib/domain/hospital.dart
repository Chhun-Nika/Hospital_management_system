import 'dart:collection';
import 'package:hospital_management_system/domain/appointment.dart';
import 'package:hospital_management_system/domain/doctor.dart';
import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/nurse.dart';
import 'package:hospital_management_system/domain/patient.dart';
import 'package:hospital_management_system/domain/time_slot.dart';

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

  // these functions are use to add all doctors from json to current object
  void addDoctors(Map<String, Doctor> doctors) {
    _doctors.addAll(doctors);
  }

  void addPatients(Map<String, Patient> patients) {
    _patients.addAll(patients);
  }

  void addAppointments(Map<String, Appointment> appointments) {
    _appointments.addAll(appointments);
  }

  void addNurses(Map<String, Nurse> nurses) {
    _nurses.addAll(nurses);
  }

  // these functions are use to add single staff in creating staff mode
  void addNurse(Nurse nurse) {
    _nurses[nurse.staffId] = nurse;
  }

  void addDoctor(Doctor doctor) {
    _doctors[doctor.staffId] = doctor;
  }

  void addPatient(Patient patient) {
    _patients[patient.patientId] = patient;
  }

  void addAppointment(Appointment appointment) {
    _appointments[appointment.appointmentId] = appointment;
  }

  // for accessing and selecting each doctors via number instead of id
  List<MapEntry<String, Doctor>> getDoctorEntries() {
    return _doctors.entries.toList();
  }

  List<MapEntry<String, Patient>> getPatientEntries() {
    return _patients.entries.toList();
  }

  List<MapEntry<String, Nurse>> getNurseEntries() {
    return _nurses.entries.toList();
  }

  // AI helps not fully generated
  // List<Doctor> getEligibleDoctorsForNurse(
  //   Map<DayOfWeek, List<TimeSlot>> nurseSchedule,
  // ) {
  //   final avaibleDoctors = doctors.values.where((doctor) {
  //     // go through nurse working schedule
  //     return nurseSchedule.entries.every((entry) {
  //       // if a nurse working slot that contains key same as any doctor slots
  //       // it will return the list of slots else it returns empty slot
  //       final doctorSlots = doctor.workingSchedule[entry.key] ?? [];
  //       // this will be true unless all any doctor slots has startTime after the nurse and endTIme before nurse
  //       return entry.value.every(
  //         (nurseSlot) => doctorSlots.any(
  //           (docSlot) =>
  //               !nurseSlot.startTime.isBefore(
  //                 docSlot.startTime,
  //               ) && // nurse start >= doctor start
  //               !nurseSlot.endTime.isAfter(docSlot.endTime),
  //         ),
  //       );
  //     });
  //   });
  //   return avaibleDoctors.toList();
  // }
  List<Doctor> getEligibleDoctorsForNurse(
    Map<DayOfWeek, List<TimeSlot>> nurseSchedule,
  ) {
    return doctors.values.where((doctor) {
      // Only consider days that doctor has shifts
      final nurseDaysWithDoctor = nurseSchedule.entries.where(
        (entry) => doctor.workingSchedule.containsKey(entry.key),
      );

      // If none of the nurse shifts match any doctor days, skip
      if (nurseDaysWithDoctor.isEmpty) return false;

      return nurseDaysWithDoctor.every((entry) {
        final doctorSlots = doctor.workingSchedule[entry.key]!;
        return entry.value.every(
          (nurseSlot) => doctorSlots.any(
            (docSlot) =>
                !(nurseSlot.endTime.isBefore(docSlot.startTime) ||
                    nurseSlot.startTime.isAfter(docSlot.endTime)),
          ),
        );
      });
    }).toList();
  }

  String getNursesForDoctorFormatted(String doctorId) {
    final nursesForDoctor = _nurses.values
        .where((nurse) => nurse.doctorId == doctorId)
        // change nurse object to nurse.name for displaying
        .map((nurse) => nurse.name)
        .toList();

    if (nursesForDoctor.isEmpty) return "No nurses assigned";

    return nursesForDoctor.join('\n');
  }

  String getDoctorName(String doctorId) {
    final doctor = _doctors[doctorId];
    if (doctor == null) {
      return "No assigned Doctor";
    }
    return 'Dr. ${doctor.name}';
  }
}
