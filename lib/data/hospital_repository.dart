import 'package:hospital_management_system/data/appointment_repository.dart';
import 'package:hospital_management_system/data/doctor_repository.dart';
import 'package:hospital_management_system/data/patient_repository.dart';
import 'package:hospital_management_system/domain/hospital.dart';

class HospitalRepository {
  final DoctorRepository doctorRepo;
  final PatientRepository patientRepo;
  final AppointmentRepository appointmentRepo;

  HospitalRepository({required this.doctorRepo, required this.patientRepo, required this.appointmentRepo});

  Hospital loadAll() {
    final hospital = Hospital();

    // Load doctors and patients
    hospital.addDoctors(doctorRepo.readAll());
    hospital.addPatients(patientRepo.readAll());
    hospital.addAppointment(appointmentRepo.readAll());

    return hospital;
  }
}
