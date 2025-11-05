import 'dart:io';

import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/hospital.dart';
import 'package:hospital_management_system/domain/staff.dart';
import 'package:hospital_management_system/domain/time_slot.dart';
import 'package:hospital_management_system/main.dart';

abstract class StaffConsole<T extends Staff> {
  final Hospital hospital;
  StaffConsole({required this.hospital});

  void startConsole();

  void viewStaff();

  void pressToExit() {
    String userInput;
    do {
      stdout.write("(enter 'q' to return): ");
      userInput = stdin.readLineSync() ?? '';
    } while (userInput.trim().toLowerCase() != 'q');
  }


  // update Name
  void updateName(MapEntry<String, T> selectedStaff) {
    print("\n-- Update Name --\n");
    print("** Current name: ${selectedStaff.value.name}");

    do {
      stdout.write("\nEnter new name: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        print("\n** Input can't be empty. **\n");
      } else {
        if (input == selectedStaff.value.name) {
          print("\n** New input name is the same as the current name. **\n");
        } else {
          selectedStaff.value.name = input;
          print('\n** Name is updated! **\n');
          pressEnterToContinue(text: "Press enter to view updated information");
          break;
        }
      }
    } while (true);
  }


  // update gender
  void updateGender(MapEntry<String, T> selectedStaff) {
    print("\n-- Update Gender --\n");
    print("** Current gender: ${selectedStaff.value.gender.name}");
    // display gender
    print("Available Genders:");
    print("  - Female");
    print("  - Male");
    print("  - Other");

    do {
      stdout.write('\nEnter new gender (can be lower case): ');
      String input = stdin.readLineSync() ?? '';
      if (input.trim().isEmpty) {
        print("\n** Input can't be empty. **\n");
      } else {
        if (input.toLowerCase() == selectedStaff.value.gender.name) {
          print(
            "\n** New input gender is the same as the current gender. **\n",
          );
        } else {
          late Gender newGender;
          switch (input.toLowerCase()) {
            case 'female':
              newGender = Gender.female;
              break;
            case 'male':
              newGender = Gender.male;
              break;
            case 'other':
              newGender = Gender.other;
              break;
            default:
              print('Invalid input.');
              continue;
          }
          selectedStaff.value.gender = newGender;
          print('\n** Gender is updated! **\n');
          pressEnterToContinue(text: "Press enter to view updated information");
          break;
        }
      }
    } while (true);
  }

  void updateEmail(MapEntry<String, T> selectedStaff) {
    print("\n-- Update Email --\n");
    print("** Current Email: ${selectedStaff.value.email}");

    do {
      stdout.write("\nEnter new email: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        print("\n** Input can't be empty. **\n");
      } else {
        if (!input.contains('@') || !input.contains('.')) {
          print("\n** Email must contains these symbols: '@' and '.' **\n");
          continue;
        } else if (input == selectedStaff.value.email) {
          print("\n** New input Specialization is the same as the current specialization. **\n");
        } else {
          selectedStaff.value.email = input;
          print('\n** email is updated! **\n');
          pressEnterToContinue(text: "Press enter to view updated information");
          break;
        }
      }
    } while (true);
  }

  void updatePhoneNumber(MapEntry<String, T> selectedStaff) {
    print("\n-- Update Phone Number --\n");
    print("** Current Email: ${selectedStaff.value.phoneNumber}");

    do {
      stdout.write("\nEnter new phone number: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        print("\n** Input can't be empty. **\n");
      } else {
        if (input.length < 9) {
          print("\n** The length of phone number must be at least 9 **\n");
          continue;
        } else if (input == selectedStaff.value.phoneNumber) {
          print("\n** New input Phone number is the same as the current Phone number. **\n");
        } else {
          selectedStaff.value.phoneNumber = input;
          print('\n** Phone number is updated! **\n');
          pressEnterToContinue(text: "Press enter to view updated information");
          break;
        }
      }
    } while (true);
  }

  void updateWorkingSchedule(MapEntry<String, T> selectedStaff) {
    print("\n-- Update Working Schedule --\n");
    print("** Current Working Schedule: ");
    final List<MapEntry<DayOfWeek, List<TimeSlot>>> workingSchedule = selectedStaff.value.getWorkingScheduleEntries();
    
  }


}