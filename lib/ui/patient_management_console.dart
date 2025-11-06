import 'dart:io';

import 'package:cli_table/cli_table.dart';
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
          pressEnterToContinue();
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

  void viewPatient() {
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

    print("** Select patient by No to view their Appointment detail. **");

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
        print("\n** Invalid number. Please try again. **");
        continue;
      }

      final selectedPatient = patients[noNumber - 1].value;

      if (selectedPatient.appointmentIds.isEmpty) {
        print("\n ** This patient has no Appointment. **");
        pressEnterToContinue();
        clearScreen();
        print(table);
        continue;
      }

      viewAppointment(selectedPatient.appointmentIds);
      pressEnterToContinue();
      clearScreen();
      print(table);
    } while (true);
  }

  void viewAppointment(List<String> appointmentId) {
    print("\n-- View Appointment Detail --\n");
    final headers = [
      'No',
      'AppointmeatID',
      'DoctorId',
      'AppointmentDateTime',
      'Duration',
      'Reason',
      'Status',
      'DoctorNote',
    ];

    final List<List<dynamic>> rows = [];
    int number = 1;

    for (var appointmentId in appointmentId) {
      var app = hospital.appointments[appointmentId];
      if (app != null) {
        rows.add([
          number,
          app.appointmentId,
          app.doctorId,
          app.appointmentDateTime.toLocal().toString().split('.')[0],
          '${app.duration} hours',
          app.reason,
          app.appointmentStatus.name,
          app.doctorNotes ?? 'null',
        ]);
        number++;
      }
    }

    if (rows.isEmpty) {
      print("\n** No valid appointments found for this patient. **");
      return;
    }

    final table = Table(header: headers);
    table.addAll(rows);
    print(table);
  }

  void updatePatient() {
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
          print("Invalid choice. Try again.");
          pressEnterToContinue(text: "Press enter to input again.");
      }
    } while (stillUpdate);
  }

  void updateName(MapEntry<String, Patient> selectedPatient) {
    print("\n-- Update Name --\n");
    print("** Current name: ${selectedPatient.value.fullName}");

    do {
      stdout.write("\nEnter new name: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        print("\n** Input can't be empty. **\n");
      } else {
        if (input == selectedPatient.value.fullName) {
          print("\n** New input name is the same as the current name. **\n");
        } else {
          selectedPatient.value.fullName = input;
          print('\n** Name is updated! **\n');
          pressEnterToContinue(text: "Press enter to view updated information");
          break;
        }
      }
    } while (true);
  }

  // update gender
  void updateGender(MapEntry<String, Patient> selectedPatient) {
    print("\n-- Update Gender --\n");
    print("** Current gender: ${selectedPatient.value.gender.name}");
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
        if (input.toLowerCase() == selectedPatient.value.gender.name) {
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
          selectedPatient.value.gender = newGender;
          print('\n** Gender is updated! **\n');
          pressEnterToContinue(text: "Press enter to view updated information");
          break;
        }
      }
    } while (true);
  }

  void updateDateOfBirth(MapEntry<String, Patient> selectedPatient) {
    print('\n -- Update Date Of Birth --\n');
    print(
      "** current date of birth: ${selectedPatient.value.dateOfBirth.toLocal().toString().split(' ')[0]}",
    );
    do {
      stdout.write("\nEnter new date of birth: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        print("\n** Input can't be empty. **\n");
        continue;
      }

      try {
        // Try to parse input into a DateTime
        DateTime parsedDate = DateTime.parse(input);

        // Optional: ensure date is in the past
        if (parsedDate.isAfter(DateTime.now())) {
          print("\n** Date of Birth cannot be in the future. **\n");
          continue;
        }
        if (parsedDate == selectedPatient.value.dateOfBirth) {
          print("\n** New date is the same as current one. **\n");
          continue;
        }

        // Update the patient's date of birth
        selectedPatient.value.dateOfBirth = parsedDate;
        print('\n** Date of Birth updated successfully! **\n');
        pressEnterToContinue(text: "Press enter to view updated information");
        break;
      } catch (e) {
        print("\n** Invalid date format. Please use YYYY-MM-DD. **\n");
      }
    } while (true);
  }

  void updateAddress(MapEntry<String, Patient> selectedPatient) {
    print("\n-- Update Address --\n");
    print("** Current Email: ${selectedPatient.value.address}");

    do {
      stdout.write("\nEnter new address: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        print("\n** Input can't be empty. **\n");
      } else {
        if (input == selectedPatient.value.address) {
          print("\n** New input address is the same as the current name. **\n");
        } else {
          selectedPatient.value.address = input;
          print('\n** Address is updated! **\n');
          pressEnterToContinue(text: "Press enter to view updated information");
          break;
        }
      }
    } while (true);
  }

  void updatePhoneNumber(MapEntry<String, Patient> selectedPatient) {
    print("\n-- Update Phone Number --\n");
    print("** Current Email: ${selectedPatient.value.phoneNumber}");

    do {
      stdout.write("\nEnter new phone number: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        print("\n** Input can't be empty. **\n");
      } else {
        if (input.length < 9) {
          print("\n** The length of phone number must be at least 9 **\n");
          continue;
        } else if (input == selectedPatient.value.phoneNumber) {
          print(
            "\n** New input Phone number is the same as the current Phone number. **\n",
          );
        } else {
          selectedPatient.value.phoneNumber = input;
          print('\n** Phone Number is updated! **\n');
          pressEnterToContinue(text: "Press enter to view updated information");
          break;
        }
      }
    } while (true);
  }

  void updateEmergencyContact(MapEntry<String, Patient> selectedPatient) {
    print("\n-- Update Emergency Contact --\n");
    print("** Current Email: ${selectedPatient.value.emergencyContact}");

    do {
      stdout.write("\nEnter new emergency contact: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        print("\n** Input can't be empty. **\n");
      } else {
        if (input.length < 9) {
          print("\n** The length of emergency contact must be at least 9 **\n");
          continue;
        } else if (input == selectedPatient.value.emergencyContact) {
          print(
            "\n** New input Emergency Contact is the same as the current Phone number. **\n",
          );
        } else {
          selectedPatient.value.emergencyContact = input;
          print('\n** Emergency Contact is updated! **\n');
          pressEnterToContinue(text: "Press enter to view updated information");
          break;
        }
      }
    } while (true);
  }

  // AI-generated : fucntion warning message
  void warning(String message) {
    // ANSI escape code for yellow text
    const yellow = '\x1B[33m';
    const reset = '\x1B[0m';
    print('\n$yellow WARNING: $message$reset');
  }

  void createPatientWithAppointment() {
    warning("All information must be filled in order to create new Patient.\n");
    String name;
    Gender gender;
    DateTime dateOfBirth;
    String phoneNumber;
    String address;
    String emergencyContact;

    while (true) {
      stdout.write('- Name: ');
      String inputName = stdin.readLineSync() ?? '';
      if (inputName.trim().isEmpty) {
        warning("\n** Name Cannot be Empty **\n");
      } else {
        name = inputName;
        break;
      }
    }

    while (true) {
      stdout.write('- Gender (male or female): ');
      String inputGender = stdin.readLineSync() ?? '';
      if (inputGender == 'male') {
        gender = Gender.male;
        break;
      } else if (inputGender == 'female') {
        gender = Gender.female;
        break;
      } else {
        warning("\n** Please enter either 'male' or 'female' **\n");
      }
    }

    while (true) {
      stdout.write('- Date Of Birth (yyyy-mm-dd): ');
      String inputDob = stdin.readLineSync() ?? '';
      try {
        dateOfBirth = DateTime.parse(inputDob);
        break;
      } catch (e) {
        print("Invalid date format, try again.");
      }
    }

    while (true) {
      stdout.write('- Phone Number: ');
      String inputPhone = stdin.readLineSync() ?? '';
      if (inputPhone.trim().isEmpty) {
        warning("\n** Name Cannot be Empty **\n");
      } else {
        phoneNumber = inputPhone;
        break;
      }
    }

    while (true) {
      stdout.write('- Address: ');
      String inputAddress = stdin.readLineSync() ?? '';
      if (inputAddress.trim().isEmpty) {
        warning("\n** Name Cannot be Empty **\n");
      } else {
        address = inputAddress;
        break;
      }
    }

    while (true) {
      stdout.write('- Emergency Contact: ');
      String inputEmer = stdin.readLineSync() ?? '';
      if (inputEmer.trim().isEmpty) {
        warning("\n** Name Cannot be Empty **\n");
      } else {
        emergencyContact = inputEmer;
        break;
      }
    }

    Patient newPatient = Patient(
      fullName: name,
      gender: gender,
      dateOfBirth: dateOfBirth,
      phoneNumber: phoneNumber,
      address: address,
      emergencyContact: emergencyContact,
      appointmentIds: [],
    );
    hospital.addPatient(newPatient);

    clearScreen();
    // create their appointment
    print("\n** Create ${newPatient.fullName}'s Appointment **\n");
    appointmentConsole?.createAppointment(newPatient.patientId);
  
  }
}
