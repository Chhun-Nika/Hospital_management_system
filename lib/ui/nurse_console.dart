import 'dart:io';

import 'package:cli_table/cli_table.dart';
import 'package:hospital_management_system/domain/nurse.dart';
import 'package:hospital_management_system/main.dart';
import 'package:hospital_management_system/ui/staff_console.dart';

class NurseConsole extends StaffConsole<Nurse> {

  NurseConsole({required super.hospital});

  @override
  void startConsole() {
    bool inSubmenu = true;
    do {
      clearScreen();
      print('-- Nurse Management --\n');
      print('1. View all Nurses');
      print('2. Create new nurse');
      print('3. Update Nurses Information');
      print('0. Exit to Staff Management\n');

      String? userInput;
      stdout.write("Enter your choice: ");
      userInput = stdin.readLineSync();

      switch (userInput) {
        case '1':
          viewStaff();
          pressToExit();
          break;
        case '2':
          createStaff();
          pressEnterToContinue();
          break;
        case '0':
          inSubmenu = false;
          break;
        default:
          print("Invalid choice. Try again.");
          pressEnterToContinue();
      }
    } while (inSubmenu);
  }

  @override
  void viewStaff() {
    clearScreen();
    if (hospital.nurses.isEmpty) {
      print("No Nurses.");
    }
    print("-- Nurses --");
    final headers = [
      'No.',
      'Name',
      'Gender',
      'Email',
      'Phone Number',
      'Working Schedule',
      'Assistant of',
    ];
    final List<List<dynamic>> rows = [];
    int number = 1;

    hospital.nurses.forEach((id, nurse) {
      String formatName = 'Nurse. ${nurse.name}';
      rows.add([
        // nurse.staffId,
        number,
        formatName,
        nurse.gender.name,
        nurse.email,
        nurse.phoneNumber,
        nurse.formatWorkingSchedule(),
        hospital.getDoctorName(nurse.doctorId)
      ]);
      number++;
    });

    final table = Table(header: headers);
    table.addAll(rows);
    print(table);
  }


  
}
