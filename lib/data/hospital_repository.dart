import 'package:hospital_management_system/data/appointment_repository.dart';
import 'package:hospital_management_system/data/doctor_repository.dart';
import 'package:hospital_management_system/data/nurse_repository.dart';
import 'package:hospital_management_system/data/patient_repository.dart';
import 'package:hospital_management_system/domain/hospital.dart';

class HospitalRepository {
  final DoctorRepository doctorRepo;
  final PatientRepository patientRepo;
  final AppointmentRepository appointmentRepo;
  final NurseRepository nurseRepo;

  HospitalRepository({
    required this.doctorRepo,
    required this.patientRepo,
    required this.appointmentRepo,
    required this.nurseRepo,
  });

  Hospital loadAll() {
    final hospital = Hospital();

    // Load doctors and patients
    hospital.addDoctors(doctorRepo.readAll());
    hospital.addPatients(patientRepo.readAll());
    hospital.addAppointments(appointmentRepo.readAll());
    hospital.addNurses(nurseRepo.readAll());

    return hospital;
  }

  void saveAll(Hospital hospital) {
    doctorRepo.writeAll(hospital.doctors);
    nurseRepo.writeAll(hospital.nurses);
    patientRepo.writeAll(hospital.patients);
    appointmentRepo.writeAll(hospital.appointments);
  }
}
