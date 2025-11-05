import 'dart:io';

import 'package:hospital_management_system/domain/hospital.dart';
import 'package:hospital_management_system/main.dart';
import 'package:hospital_management_system/ui/doctor_console.dart';

class StaffManagementConsole {
  final Hospital hospital;
  final DoctorConsole doctorConsole;
  StaffManagementConsole({required this.hospital})
    : doctorConsole = DoctorConsole(hospital: hospital);

  void startStaffManagementConsole() {
    bool inSubmenu = true;

    print('-- Staff Management --\n');
    print('1. Doctors');
    print('2. Nurses');
    print('0. Back to Main Menu\n');

    do {
      stdout.write('Enter your choice: ');
      String choice = stdin.readLineSync() ?? '';

      switch (choice.trim()) {
        case '1':
          clearScreen();
          doctorConsole.startConsole();
          break;
        case '2':
          print('Listing staff...');
          stdout.write('Press Enter to continue...');
          stdin.readLineSync();
          break;
        case '0':
          // use to exit from the submenu, redirect to main menu
          inSubmenu = false;
          break;
        default:
          print('Invalid choice. Try again.');
      }

      // clearScreen();
    } while (inSubmenu);
  }
}
