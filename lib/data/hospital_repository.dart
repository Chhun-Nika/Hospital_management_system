
import 'package:hospital_management_system/data/doctor_repository.dart';
import 'package:hospital_management_system/domain/hospital.dart';

class HospitalRepository {
  final DoctorRepository doctorRepo; 

  HospitalRepository({required this.doctorRepo});


  Hospital loadAll() {
    final hospital = Hospital();
    hospital.addDoctors(doctorRepo.readAll());

    return hospital;
  }

  
}