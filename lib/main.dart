import 'dart:io';
import 'package:hospital_management_system/data/doctor_repository.dart';
import 'package:hospital_management_system/data/hospital_repository.dart';
import 'package:hospital_management_system/domain/hospital.dart';
import 'package:hospital_management_system/ui/staff_management_console.dart';

void main() {
  clearScreen();

  final doctorPath = DoctorRepository('data/doctors.json');
  final HospitalRepository hospitalRepository = HospitalRepository(doctorRepo: doctorPath);
  final Hospital hospital;
  hospital = hospitalRepository.loadAll();

  final StaffManagementConsole staffConsole = StaffManagementConsole(hospital: hospital);

  do {
    clearScreen(); // Clear terminal at the start of each loop
    print("-- Welcome to Hospital Management System! --\n");
    print('1. Staffs Management');
    print('2. Appointments Management');
    print('0. Exit\n');

    stdout.write('Enter your choice: ');
    String? userInput = stdin.readLineSync();

    switch (userInput) {
      case '1':
        clearScreen();
        staffConsole.startStaffManagementConsole();
        break;
      case '2':
        print('hello');
        break;
      case '0':
        exit(0);
      default:
        print('Please input a valid choice');
        pressEnterToContinue();
    }
  } while (true);
}

// AI-generated
void clearScreen() {
  if (Platform.isWindows) {
    // Windows clear
    Process.runSync('cls', [], runInShell: true);
  } else {
    // macOS/Linux clear + scrollback
    stdout.write('\x1B[2J\x1B[1;1H\x1B[3J');
  }
}

void pressEnterToContinue() {
  stdout.write('Press Enter to continue...');
  stdin.readLineSync();
}
