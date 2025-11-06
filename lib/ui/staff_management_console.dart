import 'dart:io';

import 'package:hospital_management_system/domain/hospital.dart';
import 'package:hospital_management_system/main.dart';
import 'package:hospital_management_system/ui/doctor_console.dart';
import 'package:hospital_management_system/ui/nurse_console.dart';

class StaffManagementConsole {
  final Hospital hospital;
  final DoctorConsole doctorConsole;
  final NurseConsole nurseConsole;
  StaffManagementConsole({required this.hospital})
    : doctorConsole = DoctorConsole(hospital: hospital),
      nurseConsole = NurseConsole(hospital: hospital);

  void startStaffManagementConsole() {
    bool inSubmenu = true;

    do {
      clearScreen();
      print('-- Staff Management --\n');
      print('1. Doctors');
      print('2. Nurses');
      print('0. Back to Main Menu\n');
      stdout.write('Enter your choice: ');
      String choice = stdin.readLineSync() ?? '';

      switch (choice.trim()) {
        case '1':
          clearScreen();
          doctorConsole.startConsole();
          break;
        case '2':
          clearScreen();
          nurseConsole.startConsole();
          break;
        case '0':
          // use to exit from the submenu, redirect to main menu
          inSubmenu = false;
          break;
        default:
          warning('Invalid choice. Try again.');
      }

      // clearScreen();
    } while (inSubmenu);
  }
}
