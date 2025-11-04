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

    do {
      print('-- Staff Management --\n');
      print('1. Doctors');
      print('2. Nurses');
      print('0. Back to Main Menu\n');

      stdout.write('Enter your choice: ');
      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          doctorConsole.startDoctorConsole();
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
          stdout.write('Press Enter to continue...');
          stdin.readLineSync();
      }

      clearScreen();
    } while (inSubmenu);
  }
}
