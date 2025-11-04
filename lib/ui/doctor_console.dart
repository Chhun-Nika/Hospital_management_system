import 'dart:io';

import 'package:hospital_management_system/domain/hospital.dart';
import 'package:hospital_management_system/main.dart';

class DoctorConsole {
  final Hospital hospital;
  DoctorConsole({required this.hospital});

  void startDoctorConsole() {
    bool inSubmenu = true;
    do {
      print('-- Doctor Management --');
      print('1. View all Doctors');
      print('2. Update Doctors Information');
      print('0. Exit to Staff Management');

      String? userInput;
      stdout.write("Enter your choice: ");
      userInput = stdin.readLineSync();

      switch (userInput) {
        case '1':
          pressEnterToContinue();
          break;
        case '2':
          pressEnterToContinue();
        case '0':
          inSubmenu = false;
          break;
        default:
          print("Invalid choice. Try again.");
          pressEnterToContinue();
      }
    } while (inSubmenu);
  }

}
