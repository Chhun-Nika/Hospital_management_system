import 'dart:io';

import 'package:cli_table/cli_table.dart';
import 'package:hospital_management_system/domain/hospital.dart';
import 'package:hospital_management_system/main.dart';


class DoctorConsole {
  final Hospital hospital;
  DoctorConsole({required this.hospital});

  void startDoctorConsole() {
    bool inSubmenu = true;
    do {
      clearScreen();
      print('-- Doctor Management --\n');
      print('1. View all Doctors');
      print('2. Update Doctors Information');
      print('0. Exit to Staff Management\n');

      String? userInput;
      stdout.write("Enter your choice: ");
      userInput = stdin.readLineSync();

      switch (userInput) {
        case '1':
          clearScreen();
          print("-- Doctors --");
          viewDoctors();
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

  void viewDoctors () {
    if(hospital.doctors.isEmpty) {
      print("No Doctors.");
    }
    final headers = ['No.', 'Name', 'Gender', 'Email', 'Phone Number', 'Working Schedule'];
    final List<List<dynamic>> rows = [];
    int number = 1;
    hospital.doctors.forEach((id, doc) {
      rows.add([
        // doc.staffId,
        number,
        doc.name,
        doc.gender.name,
        doc.email,
        doc.phoneNumber,
        doc.formatWorkingSchedule()
      ]);
      number++;
    });

    final table = Table(header: headers);
    table.addAll(rows);
    print(table);
  }

  void updateDoctor () {
    viewDoctors();
    
  }

}
