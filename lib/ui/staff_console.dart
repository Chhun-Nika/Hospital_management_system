import 'dart:io';

import 'package:hospital_management_system/domain/doctor.dart';
import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/hospital.dart';
import 'package:hospital_management_system/domain/nurse.dart';
import 'package:hospital_management_system/domain/staff.dart';
import 'package:hospital_management_system/domain/time_of_day.dart';
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
    clearScreen();
    print("\n-- Update Name --\n");
    print("** Current name: ${selectedStaff.value.name}");

    do {
      stdout.write("\nEnter new name: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        warning("\n** Input can't be empty. **\n");
        continue;
      }
      String? message = selectedStaff.value.updateName(input);
      if (message != null) {
        warning("\n** $message **\n");
        continue;
      }
      success('\n** Name is updated! **\n');
      pressEnterToContinue(text: "Press enter to view updated information");
      break;
    } while (true);
  }

  // update gender
  void updateGender(MapEntry<String, T> selectedStaff) {
    clearScreen();
    print("\n-- Update Gender --\n");
    print("** Current gender: ${selectedStaff.value.gender.name}");
    // display gender

    do {
      stdout.write('\nEnter new gender (male, female, other): ');
      String input = stdin.readLineSync() ?? '';
      if (input.trim().isEmpty) {
        warning("\n** Input can't be empty. **\n");
        continue;
      }
      Gender? newGender;
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
          warning('Invalid input. Try again');
          continue;
      }
      String? message = selectedStaff.value.updateGender(newGender);
      if (message != null) {
        warning("\n** $message **\n");
        continue;
      }
      success('\n** Gender is updated! **\n');
      pressEnterToContinue(text: "Press enter to view updated information");
      break;
    } while (true);
  }

  void updateEmail(MapEntry<String, T> selectedStaff) {
    clearScreen();
    print("\n-- Update Email --\n");
    print("** Current Email: ${selectedStaff.value.email}");

    do {
      stdout.write("\nEnter new email: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        warning("\n** Input can't be empty. **\n");
        continue;
      }

      String? message = selectedStaff.value.updateEmail(input);
      if (message != null) {
        warning("\n** $message **\n");
        continue;
      }
      success('\n** Email is updated! **\n');
      pressEnterToContinue(text: "Press enter to view updated information");
      break;
    } while (true);
  }

  void updatePhoneNumber(MapEntry<String, T> selectedStaff) {
    clearScreen();
    print("\n-- Update Phone Number --\n");
    print("** Current Email: ${selectedStaff.value.phoneNumber}");

    do {
      stdout.write("\nEnter new phone number: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        warning("\n** Input can't be empty. **\n");
        continue;
      }
      String? message = selectedStaff.value.updatePhoneNumber(input);
      if (message != null) {
        warning("\n** $message **\n");
        continue;
      }
      success('\n** Phone number is updated! **\n');
      pressEnterToContinue(text: "Press enter to view updated information");
      break;
    } while (true);
  }

  void updateWorkingSchedule(MapEntry<String, T> selectedStaff) {
    final List<MapEntry<DayOfWeek, List<TimeSlot>>> workingSchedule =
        selectedStaff.value.getWorkingScheduleEntries();
    bool isUpdate = true;

    do {
      print("\n-- Update Working Schedule --\n");
      print("\nOptions: ");
      print('  1. Add new shift');
      print('  2. Delete shift');
      print('  0. Exit update working schedule mode');

      stdout.write('\nEnter your choice: ');
      String input = stdin.readLineSync() ?? '';
      switch (input.trim()) {
        case '1':
          inputAddShift(selectedStaff, workingSchedule);
          clearScreen();
          break;
        case '2':
          inputDeleteShift(selectedStaff, workingSchedule);
          clearScreen();
          break;
        case '0':
          isUpdate = false;
        default:
          warning("\n** Invalid input. Try again. **");
          pressEnterToContinue();
      }
    } while (isUpdate);

    // pressEnterToContinue();
  }

  void inputAddShift(
    MapEntry<String, T> selectedStaff,
    List<MapEntry<DayOfWeek, List<TimeSlot>>> workingSchedule,
  ) {
    clearScreen();
    print("** Current Working Schedule: ");

    int counter = 1;
    for (var entry in workingSchedule) {
      final day = entry.key;
      final slots = entry.value;
      print("\n${day.name}: ");
      for (var slot in slots) {
        print(
          "  $counter. ${slot.startTime.format()} - ${slot.endTime.format()}",
        );
        counter++;
      }
    }
    print("\n-- Add new shift --\n");
    print("Select day of the week: \n");
    for (var day in DayOfWeek.values) {
      print("  ${day.index + 1}. ${day.name}");
    }

    DayOfWeek? selectedDay;

    while (selectedDay == null) {
      stdout.write('\nEnter number: ');
      String input = stdin.readLineSync() ?? '';
      int? parseInput = int.tryParse(input);
      if (parseInput == null ||
          parseInput < 1 ||
          parseInput > DayOfWeek.values.length) {
        print("\n** Invalid input. Try again. **\n");
      } else {
        selectedDay = DayOfWeek.values[parseInput - 1];
      }
    }
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    print("\nInput shift startTime and endTime");
    while (startTime == null) {
      stdout.write('- Enter start time (HH:MM): ');
      String startInput = stdin.readLineSync() ?? '';
      startTime = parseTimeOfDay(startInput);
      if (startTime == null) {
        warning("\n** Invalid time format. Use HH:mm format. **\n");
      }
    }

    while (endTime == null) {
      stdout.write('- Enter end time (HH:mm): ');
      String endInput = stdin.readLineSync() ?? '';
      endTime = parseTimeOfDay(endInput);
      if (endTime == null) {
        warning("\n** Invalid time format. Use HH:mm format. **\n");
      } else if (endTime.isBefore(startTime)) {
        warning("** End time must be after start time. **");
        endTime = null;
      }
    }

    // adding the input into working schedule
    bool added = selectedStaff.value.addShift(
      selectedDay,
      TimeSlot(startTime: startTime, endTime: endTime),
    );
    if (added) {
      success("\n** Shift added successfully. **\n");
    } else {
      warning("\n** Error adding shift: Overlapping shift detected. **\n");
    }

    pressEnterToContinue();
  }

  void inputDeleteShift(
    MapEntry<String, T> selectedStaff,
    List<MapEntry<DayOfWeek, List<TimeSlot>>> workingSchedule,
  ) {
    clearScreen();
    print("-- Delete shift --\n");
    print("** Current working schedule **");
    final List<MapEntry<DayOfWeek, TimeSlot>> allShifts = [];
    int counter = 1;
    for (var entry in workingSchedule) {
      final day = entry.key;
      final slots = entry.value;
      print("\n${day.name}: ");
      for (var slot in slots) {
        print(
          "  $counter. ${slot.startTime.format()} - ${slot.endTime.format()}",
        );
        allShifts.add(MapEntry(day, slot));
        counter++;
      }
    }
    print("-------------------------------------------");
    print("\nSelect a shift to be deleted\n");

    int seletedIndex;
    while (true) {
      stdout.write('Enter shift number to delete: ');
      String input = stdin.readLineSync() ?? '';
      int? parseInput = int.tryParse(input);
      if (parseInput == null ||
          parseInput < 1 ||
          parseInput > allShifts.length) {
        warning("\n** Invalid input. Try again. **\n");
        continue;
      }

      seletedIndex = parseInput;
      break;
    }

    final shiftToDelete = allShifts[seletedIndex - 1];
    final day = shiftToDelete.key;
    final slot = shiftToDelete.value;

    String? confirm;
    while (true) {
      stdout.write(
        "Delete shift on ${day.name.toLowerCase()} "
        "(${slot.startTime.format()} - ${slot.endTime.format()})? (y/n): ",
      );
      confirm = stdin.readLineSync()?.trim().toLowerCase();

      // if the input is valid, exit the loop
      if (confirm == 'y' || confirm == 'n') {
        break;
      }

      warning("** Invalid input. Please enter 'y' or 'n'. **");
    }
    if (confirm == 'n') {
      warning("Cancelled.");
      pressEnterToContinue();
      return;
    }

    selectedStaff.value.deleteShift(day, slot);
    success("\n** Shift deleted successfully. **\n");
    pressEnterToContinue();
  }

  TimeOfDay? parseTimeOfDay(String input) {
    try {
      final parts = input.split(':');
      if (parts.length != 2) return null;
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      // check the time constraints
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
      // if it passed conditions, return the time as TimeOfDay
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return null;
    }
  }

  void createStaff() {
    clearScreen();
    print("-- Create new ${T == Nurse ? 'Nurse' : 'Doctor'} --\n");
    warning("All information must be filled in order to continue.\n");

    String name;
    Gender gender;
    String phoneNumber;
    String email;
    // make this empty string since unless the type is doctor then the specialization will be set
    String specialization = '';

    while (true) {
      stdout.write('- Name: ');
      final input = stdin.readLineSync() ?? '';
      if (input.trim().isEmpty) {
        warning("** Name cannot be empty. **\n");
        continue;
      }
      name = input;
      break;
    }

    while (true) {
      stdout.write('- Gender (female, male, other): ');
      final input = stdin.readLineSync() ?? '';
      if (input.trim().isEmpty) {
        warning("** Input cannot be empty. **\n");
        continue;
      }
      switch (input.toLowerCase()) {
        case 'female':
          gender = Gender.female;
          break;
        case 'male':
          gender = Gender.male;
          break;
        case 'other':
          gender = Gender.other;
          break;
        default:
          warning("** Invalid input. Try again. **\n");
          continue;
      }
      break;
    }

    while (true) {
      stdout.write('- Phone Number: ');
      final input = stdin.readLineSync() ?? '';
      if (input.trim().isEmpty) {
        warning("** Input cannot be empty. **\n");
        continue;
      }
      if (input.length < 9) {
        warning("** Invalid phone number format. **\n");
        continue;
      }
      phoneNumber = input;
      break;
    }

    while (true) {
      stdout.write('- Email: ');
      final input = stdin.readLineSync() ?? '';
      if (input.trim().isEmpty) {
        warning("** Input cannot be empty. **\n");
        continue;
      }
      if (!input.contains('@') || !input.contains('.')) {
        warning("** Invalid email format. **\n");
        continue;
      }
      email = input;
      break;
    }

    if (T == Doctor) {
      while (true) {
        stdout.write('- Specialization: ');
        final input = stdin.readLineSync() ?? '';
        if (input.trim().isEmpty) {
          warning("** Input cannot be empty. **\n");
          continue;
        }
        specialization = input;
        break;
      }
    }

    Map<DayOfWeek, List<TimeSlot>> workingSchedule = {};

    while (true) {
      // print("\n-- Working Schedule --");
      // for (var day in DayOfWeek.values) {
      //   print("  ${day.index + 1}. ${day.name}");
      // }

      // DayOfWeek? selectedDay;
      // while (selectedDay == null) {
      //   stdout.write('\nEnter number: ');
      //   final input = stdin.readLineSync() ?? '';
      //   final number = int.tryParse(input);
      //   if (number == null || number < 1 || number > DayOfWeek.values.length) {
      //     warning("** Invalid input. Try again. **\n");
      //   } else {
      //     selectedDay = DayOfWeek.values[number - 1];
      //   }
      // }

      // stdout.write('- Enter start time (HH:mm): ');
      // final startInput = stdin.readLineSync() ?? '';
      // final startTime = parseTimeOfDay(startInput);

      // stdout.write('- Enter end time (HH:mm): ');
      // final endInput = stdin.readLineSync() ?? '';
      // final endTime = parseTimeOfDay(endInput);

      // if (startTime == null || endTime == null) {
      //   warning("** Invalid time format. **\n");
      //   continue;
      // }

      // if (endTime.isBefore(startTime)) {
      //   warning("** End time must be after start time. **\n");
      //   continue;
      // }
      print("Select day of the week: \n");
      for (var day in DayOfWeek.values) {
        print("  ${day.index + 1}. ${day.name}");
      }

      DayOfWeek? selectedDay;

      while (selectedDay == null) {
        stdout.write('\nEnter number: ');
        String input = stdin.readLineSync() ?? '';
        int? parseInput = int.tryParse(input);
        if (parseInput == null ||
            parseInput < 1 ||
            parseInput > DayOfWeek.values.length) {
          print("\n** Invalid input. Try again. **\n");
        } else {
          selectedDay = DayOfWeek.values[parseInput - 1];
        }
      }
      TimeOfDay? startTime;
      TimeOfDay? endTime;
      print("\nInput shift startTime and endTime");
      while (startTime == null) {
        stdout.write('- Enter start time (HH:MM): ');
        String startInput = stdin.readLineSync() ?? '';
        startTime = parseTimeOfDay(startInput);
        if (startTime == null) {
          warning("\n** Invalid time format. Use HH:mm format. **\n");
        }
      }

      while (endTime == null) {
        stdout.write('- Enter end time (HH:mm): ');
        String endInput = stdin.readLineSync() ?? '';
        endTime = parseTimeOfDay(endInput);
        if (endTime == null) {
          warning("\n** Invalid time format. Use HH:mm format. **\n");
        } else if (endTime.isBefore(startTime)) {
          warning("** End time must be after start time. **");
          endTime = null;
        }
      }

      if (!workingSchedule.containsKey(selectedDay)) {
        workingSchedule[selectedDay] = [];
      }
      workingSchedule[selectedDay]!.add(
        TimeSlot(startTime: startTime, endTime: endTime),
      );

      // Ask if they want to add more schedules
      while (true) {
        stdout.write("\nAdd more working schedule? (y/n): ");
        final choice = stdin.readLineSync()?.trim().toLowerCase() ?? '';

        if (choice.isEmpty) {
          warning("** Input cannot be empty. **\n");
          continue;
        } else if (choice == 'y') {
          break;
        } else if (choice == 'n') {
          if (T == Doctor) {
            final newDoctor = hospital.createDoctor(
              name: name,
              gender: gender,
              phoneNumber: phoneNumber,
              email: email,
              specialization: specialization,
              workingSchedule: workingSchedule,
            );
            success("\n** Doctor added successfully: ${newDoctor.name} **\n");
          } else if (T == Nurse) {
            final eligibleDoctors = hospital.getEligibleDoctorsForNurse(
              workingSchedule,
            );

            String? assignedDoctorId;
            if (eligibleDoctors.isEmpty) {
              warning(
                "\n** No doctors available matching nurse's schedule. Nurse will be created without assigned doctor. **\n",
              );
            } else {
              print("\nSelect a doctor for this nurse:");
              for (int i = 0; i < eligibleDoctors.length; i++) {
                print("  ${i + 1}. ${eligibleDoctors[i].name}");
              }

              int? selectedDoctorIndex;
              while (selectedDoctorIndex == null) {
                stdout.write(
                  "\nEnter doctor number (or 0 to skip assignment): ",
                );
                final input = stdin.readLineSync() ?? '';
                final index = int.tryParse(input);
                if (index == null ||
                    index < 0 ||
                    index > eligibleDoctors.length) {
                  warning("** Invalid input. Try again. **\n");
                  continue;
                }
                if (index == 0) break; // skip assignment
                selectedDoctorIndex = index - 1;
                assignedDoctorId = eligibleDoctors[selectedDoctorIndex].staffId;
              }
            }

            final newNurse = hospital.createNurse(
              name: name,
              gender: gender,
              phoneNumber: phoneNumber,
              email: email,
              workingSchedule: workingSchedule,
              doctorId: assignedDoctorId,
            );
            if (assignedDoctorId != null) {
              success(
                "\n** Nurse added successfully and linked to ${hospital.getDoctorName(assignedDoctorId)}. **\n",
              );
            } else {
              success(
                "\n** Nurse added successfully without assigned doctor. **\n",
              );
            }
          }
          return;
        } else {
          warning("** Invalid choice. Input 'y' or 'n'. **\n");
        }
      }
    }
  }
}
