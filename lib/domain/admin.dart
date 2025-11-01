import 'package:hospital_management_system/domain/doctor.dart';
import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/nurse.dart';
import 'package:hospital_management_system/domain/staff.dart';

class Admin extends Staff {
  Admin({required super.name, required super.email, required super.phoneNumber})
    : super(role: Role.admin);

  // create doctor
  Doctor createDoctor({
    required String name,
    required String email,
    required String phoneNumber,
    required String specialization,
  }) {
    return Doctor(
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      specialization: specialization,
    );
  }

  // create nurse
  Nurse createNurse({
    required String name,
    required String phoneNumber,
    required String email,
    required String doctorId,
  }) {
    return Nurse(
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      doctorId: doctorId,
    );
  }

  // create admin
  Admin createAdmin({
    required String name,
    required String email,
    required String phoneNumber,
  }) {
    return Admin(name: name, 
      email: email, 
      phoneNumber: phoneNumber
    );
  }
}
