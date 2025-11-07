import 'dart:io';
import 'package:hospital_management_system/data/appointment_repository.dart';
import 'package:hospital_management_system/data/doctor_repository.dart';
import 'package:hospital_management_system/data/hospital_repository.dart';
import 'package:hospital_management_system/data/nurse_repository.dart';
import 'package:hospital_management_system/data/patient_repository.dart';
import 'package:hospital_management_system/domain/hospital.dart';
import 'package:hospital_management_system/ui/appointment_management_console.dart';
import 'package:hospital_management_system/ui/patient_management_console.dart';
import 'package:hospital_management_system/ui/staff_management_console.dart';

void main() {
  clearScreen();

  final doctorRepo = DoctorRepository('lib/data/doctors.json');
  final patientRepo = PatientRepository('lib/data/patient.json');
  final appointmentRepo = AppointmentRepository('lib/data/appointment.json');
  final nurseRepo = NurseRepository('lib/data/nurses.json');

  final hospitalRepository = HospitalRepository(
    doctorRepo: doctorRepo,
    patientRepo: patientRepo,
    appointmentRepo: appointmentRepo,
    nurseRepo: nurseRepo
  );

  final Hospital hospital = hospitalRepository.loadAll();

  final StaffManagementConsole staffConsole = StaffManagementConsole(
    hospital: hospital,
  );

  final PatientConsole patientConsole = PatientConsole(hospital: hospital, appointmentConsole: null);
  final AppointmentManagementConsole appointmentManagementConsole =
      AppointmentManagementConsole(hospital: hospital, doctorConsole: null, patientConsole: null);

  patientConsole.appointmentConsole = appointmentManagementConsole;
  appointmentManagementConsole.doctorConsole = staffConsole.doctorConsole;
  appointmentManagementConsole.patientConsole = patientConsole;
  do {
    clearScreen(); // Clear terminal at the start of each loop
    print("-- Welcome to Hospital Management System! --\n");
    print('1. Staffs Management');
    print('2. Appointments Management');
    print('3. Patient Management');
    print('0. Exit and save all the changes\n');

    stdout.write('Enter your choice: ');
    String userInput = stdin.readLineSync() ?? '';

    switch (userInput.trim()) {
      case '1':
        clearScreen();
        staffConsole.startStaffManagementConsole();
        break;
      case '2':
        clearScreen();
        appointmentManagementConsole.startAppointmentConsole();
        break;
      case '3':
        clearScreen();
        patientConsole.startPatientConsole();
        break;
      case '0':
        hospitalRepository.saveAll(hospital);
        print("All changes saved to file!");
        exit(0);
      default:
        print('Please input a valid choice');
      // pressEnterToContinue();
    }
  } while (true);
}

// AI-generated
void clearScreen() {
  if (Platform.isWindows) {
    // Windows clear
    stdout.write('\x1B[2J\x1B[3J\x1B[H');
  } else {
    // macOS/Linux clear + scrollback
    stdout.write('\x1B[2J\x1B[1;1H\x1B[3J');
  }
}

void pressEnterToContinue({String? text}) {
  text ??= "Press enter to continue";
  stdout.write('$text...');
  stdin.readLineSync();
}

void success(String message) => print('\x1B[32m$message\x1B[0m'); // green
void warning(String message) => print('\x1B[33m$message\x1B[0m'); // yellow
