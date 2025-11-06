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
        case '3':
          updateNurse();
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
        hospital.getDoctorName(nurse.doctorId),
      ]);
      number++;
    });

    final table = Table(header: headers);
    table.addAll(rows);
    print(table);
  }

  void updateNurse() {
    // viewDoctors();
    final List<MapEntry<String, Nurse>> nurseList = hospital.getNurseEntries();
    do {
      // clearScreen();
      viewStaff();

      print("\n-- Select a nurse to update by No. --\n");
      stdout.write('Enter your choice (q to exit): ');
      String userInput = stdin.readLineSync() ?? '';
      if (userInput.trim().isEmpty) {
        warning("\n** Input cannot be empty. **\n");
        // clearScreen();
      } else if (userInput.toLowerCase() == 'q') {
        clearScreen();
        print("-- Doctor Management --");
        viewStaff(); // Display table before returning
        break;
      } else {
        try {
          final int parseInput = int.parse(userInput);

          if (parseInput > 0 && parseInput <= nurseList.length) {
            clearScreen();
            nurseDetailDisplay(nurseList, parseInput);
          } else {
            warning(
              '\n** Please enter a valid input (refer to table No. for input range) **\n',
            );
            pressEnterToContinue();
          }
        } catch (e) {
          warning(
            '\n** Invalid input. Please enter a number or q to quit. **\n',
          );
          pressEnterToContinue();
        }
      }
    } while (true);
  }

  void nurseDetailDisplay(
    List<MapEntry<String, Nurse>> nurseList,
    int userInput,
  ) {
    final MapEntry<String, Nurse> selectedNurse = nurseList[userInput - 1];

    bool stillUpdate = true;
    String updateInput;

    do {
      clearScreen();
      String nameFormat = 'Nurse. ${selectedNurse.value.name}';
      print('Nurse. ${selectedNurse.value.name}\'s infromation');
      final headers = [
        'No.',
        'Name',
        'Gender',
        'Email',
        'Phone Number',
        'Working Schedule',
        'Assistant Of',
      ];
      final row = [
        userInput,
        nameFormat,
        selectedNurse.value.gender.name,
        selectedNurse.value.email,
        selectedNurse.value.phoneNumber,
        selectedNurse.value.formatWorkingSchedule(),
        hospital.getDoctorName(selectedNurse.value.doctorId),
      ];
      final table = Table(header: headers);
      table.add(row);
      print(table);
      print("\n-- Select any field to update --\n");
      print('1. Name');
      print('2. Gender');
      print('3. Email');
      print('4. Phone Number');
      print('5. Working Schedule');
      print('6. Assign to Doctor');
      print('0. Exit update mode to main update page');

      stdout.write('\nEnter your choice: ');
      updateInput = stdin.readLineSync() ?? '';
      switch (updateInput.trim()) {
        case '1':
          updateName(selectedNurse);
          break;
        case '2':
          updateGender(selectedNurse);
          break;
        case '3':
          updateEmail(selectedNurse);
          break;
        case '4':
          updatePhoneNumber(selectedNurse);
          break;
        case '5':
          updateWorkingSchedule(selectedNurse);
          break;
        case '6':
          updateAssignedDoctor(selectedNurse);
        case '0':
          stillUpdate = false;
          break;
        default:
          warning("Invalid choice. Try again.");
          pressEnterToContinue(text: "Press enter to input again.");
      }
    } while (stillUpdate);
  }

  void updateAssignedDoctor(MapEntry<String, Nurse> selectedNurse) {
    final currentDoctorId = selectedNurse.value.doctorId;
    final currentDoctorName = currentDoctorId.isNotEmpty
        ? hospital.getDoctorName(currentDoctorId)
        : 'None';

    print("\n** Current assigned doctor: $currentDoctorName");

    int? choice;
    while (choice == null) {
      print("\nOptions: ");
      print("  1. Change assigned doctor");
      print("  2. Remove assigned doctor");
      print("  0. Cancel");

      stdout.write("\nEnter your choice: ");
      final input = stdin.readLineSync() ?? '';
      final parseInput = int.tryParse(input);
      if (parseInput == null || parseInput < 0 || parseInput > 2) {
        warning("** Invalid input. Enter 0, 1, or 2. **\n");
        continue;
      }
      choice = parseInput;
    }

    switch (choice) {
      case 0:
        warning("\n** Cancelled update. **\n");
        break;
      case 2:
        selectedNurse.value.updateAssignedDoctor('');
        success("\n** Assigned doctor removed. **\n");
        pressEnterToContinue();
        break;
      case 1:
        final eligibleDoctors = hospital.getEligibleDoctorsForNurse(
          selectedNurse.value.workingSchedule,
        );
        if (eligibleDoctors.isEmpty) {
          warning("\n** No doctors available matching nurse's schedule. **\n");
          pressEnterToContinue();
          return;
        }

        int? selectedIndex;
        while (selectedIndex == null) {
          print("\nSelect a doctor for this nurse:");
          for (int i = 0; i < eligibleDoctors.length; i++) {
            print("  ${i + 1}. ${eligibleDoctors[i].name}");
          }

          stdout.write("\nEnter doctor number: ");
          final input = stdin.readLineSync() ?? '';
          final index = int.tryParse(input);
          if (index == null || index < 1 || index > eligibleDoctors.length) {
            warning("** Invalid input. Try again. **\n");
            continue;
          }
          selectedIndex = index - 1;
        }

        final message = selectedNurse.value.updateAssignedDoctor(
          eligibleDoctors[selectedIndex].staffId,
        );
        if (message != null) {
          warning(message);
        } else {
          success(
            "\n** Assigned doctor updated to ${eligibleDoctors[selectedIndex].name} **\n",
          );
        }
        pressEnterToContinue();
        break;
    }
  }
}
