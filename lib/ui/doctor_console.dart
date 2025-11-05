import 'dart:io';

import 'package:cli_table/cli_table.dart';
import 'package:hospital_management_system/domain/doctor.dart';
import 'package:hospital_management_system/main.dart';
import 'package:hospital_management_system/ui/staff_console.dart';

class DoctorConsole extends StaffConsole<Doctor> {
  DoctorConsole({required super.hospital});

  @override
  void startConsole() {
    bool inSubmenu = true;

    do {
      clearScreen();
      print('-- Doctor Management --\n');
      print('1. View all Doctors');
      print('2. Create new Doctor');
      print('3. Update Doctors Information');
      print('0. Exit to Staff Management\n');
      stdout.write("Enter your choice: ");
      String userInput = stdin.readLineSync() ?? '';

      switch (userInput.trim()) {
        case '1':
          viewStaff();
          pressToExit();
          break;
        case '2':
          pressEnterToContinue();
        case '3':
          updateDoctor();
        // pressEnterToContinue();
        case '0':
          inSubmenu = false;
          break;
        default:
          print("Invalid choice. Try again.");
        // pressEnterToContinue();
      }
    } while (inSubmenu);
  }

  @override
  void viewStaff() {
    clearScreen();
    if (hospital.doctors.isEmpty) {
      print("No Doctors.");
    }
    print("-- Doctors --");
    final headers = [
      'No.',
      'Name',
      'Gender',
      'Specialization',
      'Email',
      'Phone Number',
      'Working Schedule',
    ];
    final List<List<dynamic>> rows = [];
    int number = 1;

    hospital.doctors.forEach((id, doc) {
      String formatName = 'Dr. ${doc.name}';
      rows.add([
        // doc.staffId,
        number,
        formatName,
        doc.gender.name,
        doc.specialization,
        doc.email,
        doc.phoneNumber,
        doc.formatWorkingSchedule(),
      ]);
      number++;
    });

    final table = Table(header: headers);
    table.addAll(rows);
    print(table);
  }


  void updateDoctor() {
    // viewDoctors();
    final List<MapEntry<String, Doctor>> doctorList = hospital
        .getDoctorEntries();
    do {
      // clearScreen();
      viewStaff();

      print("\n-- Select a doctor to update by No. --\n");
      stdout.write('Enter your choice (q to exit): ');
      String userInput = stdin.readLineSync() ?? '';
      if (userInput.trim().isEmpty) {
        print("\n** Input cannot be empty. **\n");
        // clearScreen();
      } else if (userInput.toLowerCase() == 'q') {
        clearScreen();
        print("-- Doctor Management --");
        viewStaff(); // Display table before returning
        break;
      } else {
        try {
          final int parseInput = int.parse(userInput);

          if (parseInput > 0 && parseInput <= doctorList.length) {
            clearScreen();
            doctorDetailDisplay(doctorList, parseInput);
          } else {
            print(
              '\n** Please enter a valid input (refer to table No. for input range) **\n',
            );
          }
        } catch (e) {
          print('\n** Invalid input. Please enter a number or q to quit. **\n');
        }
      }
    } while (true);
  }

  void doctorDetailDisplay(
    List<MapEntry<String, Doctor>> doctorList,
    int userInput,
  ) {
    final MapEntry<String, Doctor> selectedDoctor = doctorList[userInput - 1];

    bool stillUpdate = true;
    String updateInput;
    String nameFormat = 'Dr. ${selectedDoctor.value.name}';
    do {
      clearScreen();
      print('Dr. ${selectedDoctor.value.name}\'s infromation');
      final headers = [
        'No.',
        'Name',
        'Gender',
        'Specialization',
        'Email',
        'Phone Number',
        'Working Schedule',
      ];
      final row = [
        userInput,
        nameFormat,
        selectedDoctor.value.gender.name,
        selectedDoctor.value.specialization,
        selectedDoctor.value.email,
        selectedDoctor.value.phoneNumber,
        selectedDoctor.value.formatWorkingSchedule(),
      ];
      final table = Table(header: headers);
      table.add(row);
      print(table);
      print("\n-- Select any field to update --\n");
      print('1. Name');
      print('2. Gender');
      print('3. Specialization');
      print('4. Email');
      print('5. Phone Number');
      print('6. Working Schedule');
      print('0. Exit update mode to main update page');

      stdout.write('\nEnter your choice: ');
      updateInput = stdin.readLineSync() ?? '';
      switch (updateInput.trim()) {
        case '1':
          updateName(selectedDoctor);
          break;
        case '2':
          updateGender(selectedDoctor);
          break;
        case '3':
          updateSpecialization(selectedDoctor);
          break;
        case '4':
          updateEmail(selectedDoctor);
          break;
        case '5':
          updatePhoneNumber(selectedDoctor);
          break;
        case '6':
          updateWorkingSchedule(selectedDoctor);
          break;
        case '0':
          stillUpdate = false;
          break;
        default:
          print("Invalid choice. Try again.");
          pressEnterToContinue(text: "Press enter to input again.");
      }
    } while (stillUpdate);
  }

  void updateSpecialization(MapEntry<String, Doctor> selectedDoctor) {
    print("\n-- Update Specialization --\n");
    print("** Current Specialization: ${selectedDoctor.value.specialization}");

    do {
      stdout.write("\nEnter new Specialization: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        print("\n** Input can't be empty. **\n");
      } else {
        if (input == selectedDoctor.value.specialization) {
          print("\n** New input Specialization is the same as the current specialization. **\n");
        } else {
          selectedDoctor.value.specialization = input;
          print('\n** Specialization is updated! **\n');
          pressEnterToContinue(text: "Press enter to view updated information");
          break;
        }
      }
    } while (true);
  }

  
}
