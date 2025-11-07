import 'dart:io';

import 'package:cli_table/cli_table.dart';
import 'package:hospital_management_system/domain/appointment.dart';
import 'package:hospital_management_system/domain/doctor.dart';
import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/hospital.dart';
import 'package:hospital_management_system/domain/patient.dart';
import 'package:hospital_management_system/main.dart';
import 'package:hospital_management_system/ui/appointment_management_console.dart';

class PatientConsole {
  final Hospital hospital;
  AppointmentManagementConsole? appointmentConsole;

  PatientConsole({required this.hospital, this.appointmentConsole});

  void startPatientConsole() {
    bool inSubmenu = true;
    do {
      clearScreen();
      print('--- patient management ---\n');
      print('1. View all Patient');
      print('2. Create New Patient');
      print('3. Update Patient Informations');
      print('0. Exit ');

      String? userInput;
      stdout.write("\nEnter your choice: ");
      userInput = stdin.readLineSync();

      switch (userInput) {
        case '1':
          clearScreen();
          print("-- Patients --");
          viewPatientAndAppointment();
          // pressEnterToContinue();
          break;
        case '2':
          clearScreen();
          print("-- Create New Patient --");
          createPatientWithAppointment();
          break;
        case '3':
          clearScreen();
          print("-- Update Patient --");
          updatePatient();
          // pressEnterToContinue();
          break;
        case '0':
          inSubmenu = false;
          break;
        default:
          warning("Invalid choice. Try again.");
          pressEnterToContinue();
      }
    } while (inSubmenu);
  }

  void viewPatient() {
    print("\n** Patients **\n");
    if (hospital.patients.isEmpty) {
      print('No Patients.');
    }
    final headers = [
      'No.',
      'Name',
      'Gender',
      'DateOfBirth',
      'Phone Number',
      'Address',
      'EmergencyContact',
    ];

    final List<List<dynamic>> rows = [];
    int number = 1;
    hospital.patients.forEach((id, pat) {
      rows.add([
        number,
        pat.fullName,
        pat.gender.name,
        pat.dateOfBirth.toLocal().toString().split(' ')[0],
        pat.phoneNumber,
        pat.address,
        pat.emergencyContact,
      ]);
      number++;
    });
    final table = Table(header: headers);
    table.addAll(rows);
    print(table);
  }

  void viewPatientAndAppointment() {
    if (hospital.patients.isEmpty) {
      print('No Patients.');
    }
    final headers = [
      'No.',
      'Name',
      'Gender',
      'DateOfBirth',
      'Phone Number',
      'Address',
      'EmergencyContact',
    ];

    final List<MapEntry<String, dynamic>> patients = hospital.patients.entries
        .toList();
    final List<List<dynamic>> rows = [];
    int number = 1;
    hospital.patients.forEach((id, pat) {
      rows.add([
        number,
        pat.fullName,
        pat.gender.name,
        pat.dateOfBirth.toLocal().toString().split(' ')[0],
        pat.phoneNumber,
        pat.address,
        pat.emergencyContact,
      ]);
      number++;
    });
    final table = Table(header: headers);
    table.addAll(rows);
    print(table);

    warning("** Select patient by No. to view their Appointment detail. **");

    do {
      String? input;
      stdout.write("\nEnter No (or q to quit): ");
      input = stdin.readLineSync()?.trim();
      clearScreen();

      if (input == null || input.isEmpty || input.toLowerCase() == 'q') {
        break;
      }

      final noNumber = int.tryParse(input);
      if (noNumber == null || noNumber < 1 || noNumber > patients.length) {
        warning("\n** Invalid number. Please try again. **");
        continue;
      }

      final selectedPatient = patients[noNumber - 1].value;

      if (hospital
          .getAppointmentByPatientId(selectedPatient.patientId)
          .isEmpty) {
        warning("\n ** This patient has no Appointment. **");
        pressEnterToContinue();
        clearScreen();
        print(table);
        continue;
      }

      viewAppointment(
        hospital.getAppointmentByPatientId(selectedPatient.patientId),
        selectedPatient,
      );
      pressEnterToContinue();
      clearScreen();
      print("-- Patients --\n");
      print(table);
    } while (true);
  }

  // void viewAppointment(List<Appointment> appointmentId) {
  //   print("\n-- View Appointment Detail --\n");
  //   final headers = [
  //     'No',
  //     'AppointmeatID',
  //     'DoctorId',
  //     'AppointmentDateTime',
  //     'Duration',
  //     'Reason',
  //     'Status',
  //     'DoctorNote',
  //   ];

  //   final List<List<dynamic>> rows = [];
  //   int number = 1;

  //   for (var appointmentId in appointmentId) {
  //     var app = hospital.appointments[appointmentId];
  //     if (app != null) {
  //       rows.add([
  //         number,
  //         app.appointmentId,
  //         app.doctorId,
  //         app.appointmentDateTime.toLocal().toString().split('.')[0],
  //         '${app.duration} hours',
  //         app.reason,
  //         app.appointmentStatus.name,
  //         app.doctorNotes ?? 'null',
  //       ]);
  //       number++;
  //     }
  //   }

  //   if (rows.isEmpty) {
  //     warning("\n** No valid appointments found for this patient. **");
  //     return;
  //   }

  //   final table = Table(header: headers);
  //   table.addAll(rows);
  //   print(table);
  // }
  void viewAppointment(
    List<Appointment> appointments,
    Patient selectedPatient,
  ) {
    print("\n-- View Appointment Detail --\n");
    print("Patient: ${selectedPatient.fullName}");

    final headers = [
      'No',
      'DoctorID',
      'AppointmentDateTime',
      'Duration',
      'Reason',
      'Status',
      'DoctorNote',
    ];

    final List<List<dynamic>> rows = [];
    int number = 1;

    for (var app in appointments) {
      rows.add([
        number,
        hospital.getDoctorName(app.doctorId),
        app.appointmentDateTime.toLocal().toString().split('.')[0],
        '${app.duration} hours',
        app.reason,
        app.appointmentStatus.name,
        app.doctorNotes ?? 'null',
      ]);
      number++;
    }

    if (rows.isEmpty) {
      warning("\n** No appointments found for this patient. **");
      return;
    }

    final table = Table(header: headers);
    table.addAll(rows);
    print(table);
  }

  void updatePatient() {
    clearScreen();
    final List<MapEntry<String, Patient>> patientList = hospital
        .getPatientEntries();

    do {
      viewPatient();
      print("\n-- Select a patient to update by No. --\n");
      stdout.write('Enter your choice (q to exit): ');
      String userInput = stdin.readLineSync() ?? '';
      if (userInput.trim().isEmpty) {
        print("\n** Input cannot be empty. **\n");
        // clearScreen();
      } else if (userInput.toLowerCase() == 'q') {
        clearScreen();
        print("-- Patient Management --");
        viewPatient();
        break;
      } else {
        try {
          final int parseInput = int.parse(userInput);

          if (parseInput > 0 && parseInput <= patientList.length) {
            clearScreen();
            patientDetailDisplay(patientList, parseInput);
          } else {
            warning(
              '\n** Please enter a valid input (refer to table No. for input range) **\n',
            );
          }
        } catch (e) {
          warning(
            '\n** Invalid input. Please enter a number or q to quit. **\n',
          );
        }
      }
    } while (true);
  }

  void patientDetailDisplay(
    List<MapEntry<String, Patient>> patientList,
    int userInput,
  ) {
    final MapEntry<String, Patient> selectedPatient =
        patientList[userInput - 1];
    bool stillUpdate = true;
    String updateInput;
    do {
      print('${selectedPatient.value.fullName}\'s information');
      final headers = [
        'No.',
        'Name',
        'Gender',
        'DateOfBirth',
        'Phone Number',
        'Address',
        'EmergencyContact',
      ];

      final row = [
        userInput,
        selectedPatient.value.fullName,
        selectedPatient.value.gender.name,
        selectedPatient.value.dateOfBirth.toLocal().toString().split(' ')[0],
        selectedPatient.value.phoneNumber,
        selectedPatient.value.address,
        selectedPatient.value.emergencyContact,
      ];

      final table = Table(header: headers);
      table.add(row);
      print(table);
      print("\n-- Select any field to update --\n");
      print('1. Name');
      print('2. Gender');
      print('3. DateOfBirth');
      print('4. Phone Number');
      print('5. Address');
      print('6. Emergency Contant');
      print('0. Exit update mode to main update page');

      stdout.write('\nEnter your choice: ');
      updateInput = stdin.readLineSync() ?? '';
      switch (updateInput.trim()) {
        case '1':
          updateName(selectedPatient);
          break;
        case '2':
          updateGender(selectedPatient);
          break;
        case '3':
          updateDateOfBirth(selectedPatient);
          break;
        case '4':
          updatePhoneNumber(selectedPatient);
          break;
        case '5':
          updateAddress(selectedPatient);
          break;
        case '6':
          updateEmergencyContact(selectedPatient);
          break;
        case '0':
          stillUpdate = false;
          break;
        default:
          warning("Invalid choice. Try again.");
          pressEnterToContinue(text: "Press enter to input again.");
      }
    } while (stillUpdate);
  }

  void updateName(MapEntry<String, Patient> selectedPatient) {
    clearScreen();
    print("\n-- Update Name --\n");
    print("** Current name: ${selectedPatient.value.fullName}");

    do {
      stdout.write("\nEnter new name: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        print("\n** Input can't be empty. **\n");
        continue;
      }

      String? message = selectedPatient.value.updateName(input);
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
  void updateGender(MapEntry<String, Patient> selectedPatient) {
    clearScreen();
    print("\n-- Update Gender --\n");
    print("** Current gender: ${selectedPatient.value.gender.name}");
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
      String? message = selectedPatient.value.updateGender(newGender);
      if (message != null) {
        warning("\n** $message **\n");
        continue;
      }
      success('\n** Gender is updated! **\n');
      pressEnterToContinue(text: "Press enter to view updated information");
      break;
    } while (true);
  }

  // void updateDateOfBirth(MapEntry<String, Patient> selectedPatient) {
  //   print('\n -- Update Date Of Birth --\n');
  //   print(
  //     "** current date of birth: ${selectedPatient.value.dateOfBirth.toLocal().toString().split(' ')[0]}",
  //   );
  //   do {
  //     stdout.write("\nEnter new date of birth(YYYY-MM-DD): ");
  //     String input = stdin.readLineSync() ?? '';

  //     if (input.trim().isEmpty) {
  //       print("\n** Input can't be empty. **\n");
  //       continue;
  //     }

  //     try {
  //       // Try to parse input into a DateTime
  //       DateTime parsedDate = DateTime.tryparse(input);

  //       // Optional: ensure date is in the past
  //       if (parsedDate.isAfter(DateTime.now())) {
  //         print("\n** Date of Birth cannot be in the future. **\n");
  //         continue;
  //       }
  //       if (parsedDate == selectedPatient.value.dateOfBirth) {
  //         print("\n** New date is the same as current one. **\n");
  //         continue;
  //       }

  //       // Update the patient's date of birth
  //       selectedPatient.value.dateOfBirth = parsedDate;
  //       print('\n** Date of Birth updated successfully! **\n');
  //       pressEnterToContinue(text: "Press enter to view updated information");
  //       break;
  //     } catch (e) {
  //       print("\n** Invalid date format. Please use YYYY-MM-DD. **\n");
  //     }
  //   } while (true);
  // }
  void updateDateOfBirth(MapEntry<String, Patient> selectedPatient) {
    clearScreen();
    print('\n -- Update Date Of Birth --\n');
    print(
      "** Current date of birth: ${selectedPatient.value.dateOfBirth.toLocal().toString().split(' ')[0]}",
    );

    do {
      stdout.write("\nEnter new date of birth (YYYY-MM-DD): ");
      String input = stdin.readLineSync()?.trim() ?? '';

      if (input.isEmpty) {
        print("\n** Input can't be empty. **\n");
        continue;
      }

      DateTime? parsedDate = DateTime.tryParse(input);

      if (parsedDate == null) {
        warning("\n** Invalid date format. Please use YYYY-MM-DD. **\n");
        continue;
      }

      String? message = selectedPatient.value.updateDateOfBirth(parsedDate);
      if (message != null) {
        warning("\n** $message **\n");
        continue;
      }

      // Update the patient's date of birth
      success('\n** Date of Birth updated successfully! **\n');
      pressEnterToContinue(text: "Press enter to view updated information");
      break;
    } while (true);
  }

  void updateAddress(MapEntry<String, Patient> selectedPatient) {
    clearScreen();
    print("\n-- Update Address --\n");
    print("** Current Email: ${selectedPatient.value.address}");

    do {
      stdout.write("\nEnter new address: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        warning("\n** Input can't be empty. **\n");
        continue;
      }
      String? message = selectedPatient.value.updateAddress(input);
      if (message != null) {
        warning("\n** $message **\n");
        continue;
      }
      success('\n** Address is updated! **\n');
      pressEnterToContinue(text: "Press enter to view updated information");
      break;
    } while (true);
  }

  void updatePhoneNumber(MapEntry<String, Patient> selectedPatient) {
    clearScreen();
    print("\n-- Update Phone Number --\n");
    print("** Current Email: ${selectedPatient.value.phoneNumber}");

    do {
      stdout.write("\nEnter new phone number: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        warning("\n** Input can't be empty. **\n");
        continue;
      }
      String? message = selectedPatient.value.updatePhoneNumber(input);
      if (message != null) {
        warning("\n** $message **\n");
        continue;
      }
      success('\n** Phone number is updated! **\n');
      pressEnterToContinue(text: "Press enter to view updated information");
      break;
    } while (true);
  }

  void updateEmergencyContact(MapEntry<String, Patient> selectedPatient) {
    clearScreen();
    print("\n-- Update Emergency Contact --\n");
    print("** Current Email: ${selectedPatient.value.emergencyContact}");

    do {
      stdout.write("\nEnter new emergency contact: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        print("\n** Input can't be empty. **\n");
        continue;
      }
      String? message = selectedPatient.value.updateEmergencyContact(input);
      if (message != null) {
        warning("\n** $message **\n");
        continue;
      }
      success('\n** Emergency Contact is updated! **\n');
      pressEnterToContinue(text: "Press enter to view updated information");
      break;
    } while (true);
  }

  void createPatientWithAppointment() {
    warning("All information must be filled in order to create new Patient.\n");

    String name;
    Gender gender;
    DateTime dateOfBirth;
    String phoneNumber;
    String address;
    String emergencyContact;

    // Name
    while (true) {
      stdout.write('- Name: ');
      String inputName = stdin.readLineSync() ?? '';
      if (inputName.trim().isEmpty) {
        warning("** Name cannot be empty. **\n");
      } else {
        name = inputName.trim();
        break;
      }
    }

    // Gender
    while (true) {
      stdout.write('- Gender (male, female, other): ');
      String inputGender = (stdin.readLineSync() ?? '').trim().toLowerCase();
      if (inputGender == 'male') {
        gender = Gender.male;
        break;
      } else if (inputGender == 'female') {
        gender = Gender.female;
        break;
      } else if (inputGender == 'other') {
        gender = Gender.other;
        break;
      } else {
        warning("** Invalid gender. Enter 'male', 'female', or 'other'. **\n");
      }
    }

    // Date of Birth
    // while (true) {
    //   stdout.write('- Date of Birth (yyyy-mm-dd): ');
    //   String inputDob = stdin.readLineSync() ?? '';
    //   try {
    //     dateOfBirth = DateTime.parse(inputDob);
    //     if (dateOfBirth.isAfter(DateTime.now())) {
    //       warning("** Date of birth cannot be in the future. **\n");
    //     } else {
    //       break;
    //     }
    //   } catch (e) {
    //     warning("** Invalid date format. Please use yyyy-mm-dd. **\n");
    //   }
    // }
    while (true) {
      stdout.write('- Date of Birth (yyyy-mm-dd): ');
      String inputDob = stdin.readLineSync()?.trim() ?? '';

      if (inputDob.isEmpty) {
        warning("** Date of birth cannot be empty. **\n");
        continue;
      }

      // Split manually to normalize format
      final parts = inputDob.split('-');
      if (parts.length != 3) {
        warning(
          "** Invalid date format. Please use yyyy-mm-dd (e.g., 2005-11-06). **\n",
        );
        continue;
      }

      String yearStr = parts[0];
      String monthStr = parts[1].padLeft(2, '0');
      String dayStr = parts[2].padLeft(2, '0');
      final normalized = '$yearStr-$monthStr-$dayStr';

      try {
        dateOfBirth = DateTime.parse(normalized);

        final today = DateTime.now();
        final todayOnly = DateTime(today.year, today.month, today.day);
        final dobOnly = DateTime(
          dateOfBirth.year,
          dateOfBirth.month,
          dateOfBirth.day,
        );

        if (!dobOnly.isBefore(todayOnly)) {
          warning(
            "** Date of birth must be in the past (not today or future). **\n",
          );
          continue;
        }

        break; // valid
      } catch (e) {
        warning("** Invalid date. Please enter a valid date. **\n");
      }
    }

    //Phone Number
    while (true) {
      stdout.write('- Phone Number: ');
      String inputPhone = stdin.readLineSync() ?? '';
      if (inputPhone.trim().isEmpty) {
        warning("** Phone number cannot be empty. **\n");
      } else if (inputPhone.length < 9) {
        warning("** Invalid phone number. Must be at least 9 digits. **\n");
      } else {
        phoneNumber = inputPhone.trim();
        break;
      }
    }

    // Address
    while (true) {
      stdout.write('- Address: ');
      String inputAddress = stdin.readLineSync() ?? '';
      if (inputAddress.trim().isEmpty) {
        warning("** Address cannot be empty. **\n");
      } else {
        address = inputAddress.trim();
        break;
      }
    }

    // Emergency Contact
    while (true) {
      stdout.write('- Emergency Contact: ');
      String inputEmer = stdin.readLineSync() ?? '';
      if (inputEmer.trim().isEmpty) {
        warning("** Emergency contact cannot be empty. **\n");
      } else if (inputEmer.length < 9) {
        warning(
          "** Invalid emergency contact. Must be at least 9 digits. **\n",
        );
      } else {
        emergencyContact = inputEmer.trim();
        break;
      }
    }

    // Create Patient
    final newPatient = hospital.createPatient(
      name: name,
      gender: gender,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      emergencyContact: emergencyContact,
      address: address,
    );

    clearScreen();
    print("\n** Create ${newPatient.fullName}'s Appointment **\n");

    // Create appointment if console is available
    appointmentConsole?.createAppointment(newPatient.patientId);
  }
}
