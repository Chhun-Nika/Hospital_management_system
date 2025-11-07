import 'dart:io';

import 'package:cli_table/cli_table.dart';
import 'package:hospital_management_system/domain/appointment.dart';
import 'package:hospital_management_system/domain/doctor.dart';
import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/hospital.dart';
import 'package:hospital_management_system/main.dart';
import 'package:hospital_management_system/ui/doctor_console.dart';
import 'package:hospital_management_system/ui/patient_management_console.dart';

class AppointmentManagementConsole {
  final Hospital hospital;
  DoctorConsole? doctorConsole;
  PatientConsole? patientConsole;

  AppointmentManagementConsole({
    required this.hospital,
    this.doctorConsole,
    this.patientConsole,
  });

  void startAppointmentConsole() {
    bool inSubmit = true;
    do {
      clearScreen();
      print('--- Appointment Management ---\n');
      print('1. View All Appointments');
      print('2. Create New Appointment');
      print('3. Update Appointments');
      print('0. Exit');

      String? userInput;
      stdout.write('\nEnter your choice: ');
      userInput = stdin.readLineSync();

      switch (userInput) {
        case '1':
          viewAppointment();
          pressEnterToContinue();
          break;
        case '2':
          clearScreen();
          print("-- Create Appointment --");
          createAppointmentSelectPatient();
          pressEnterToContinue();
          break;
        case '3':
          clearScreen();
          print('-- Update Appointment --');
          updateAppointment();
          // pressEnterToContinue();
        case '0':
          inSubmit = false;
          break;
        default:
          print("Invalid choice. Try again.");
          pressEnterToContinue();
      }
    } while (inSubmit);
  }

  void viewAppointment() {
    clearScreen();
    print("-- Appointments --");
    if (hospital.appointments.isEmpty) {
      print("** No Appointment **\n");
    }
    final headers = [
      'No',
      'Appointment DateTime',
      'Duration',
      'Reason',
      'Status',
      'DoctorNote',
      'Patient Name',
      'Patient Gender',
      'PhoneNumber',
      'Doctor Name',
      'Doctor Gender',
      'Specialization',
    ];

    final List<List<dynamic>> rows = [];
    int number = 1;

    hospital.appointments.forEach((id, app) {
      final pat = hospital.patients[app.patientId];
      final doc = hospital.doctors[app.doctorId];
      String formatName = 'Dr. ${doc?.name}';

      rows.add([
        number,
        app.appointmentDateTime.toLocal().toString().split('.')[0],
        '${app.duration} hours',
        app.reason,
        app.appointmentStatus.name,
        app.doctorNotes ?? 'null',
        pat?.fullName ?? 'unknown',
        pat?.gender.name,
        pat?.phoneNumber,
        formatName,
        doc?.gender.name,
        doc?.specialization,
      ]);
      number++;
    });

    final table = Table(header: headers);
    table.addAll(rows);
    print(table);
  }

  // // AI-generated : fucntion warning message
  // void warning(String message) {
  //   // ANSI escape code for yellow text
  //   const yellow = '\x1B[33m';
  //   const reset = '\x1B[0m';
  //   print('\n$yellow WARNING: $message$reset');
  // }

  void createAppointment(String patientId) {
    warning("All information must be filled in order to create Appointment.\n");

    late String doctorId;
    late DateTime appointmentDateTime;
    late int duration;
    late String reason;
    late String doctorNote;

    List<Doctor> availableDoctors = [];

    while (availableDoctors.isEmpty) {
      
      while (true) {
        stdout.write('- DateTime (yyyy-mm-dd HH:mm): ');
        final inputDate = stdin.readLineSync()?.trim();

        try {
          if (inputDate == null || inputDate.isEmpty) throw FormatException();
          appointmentDateTime = DateTime.parse(inputDate.replaceAll(' ', 'T'));

          // Check if the date is in the past
          if (appointmentDateTime.isBefore(DateTime.now())) {
            warning("** The appointment time must be current or future **\n");
            continue;
          }

          break; // valid date
        } catch (e) {
          warning("Invalid date format, try again.");
        }
      }

      while (true) {
        stdout.write('- Duration in hours: ');
        final input = stdin.readLineSync()?.trim() ?? '';
        final inputDuration = int.tryParse(input);
        if (inputDuration == null || inputDuration <= 0) {
          warning("\n** Duration cannot be negative or zero **\n");
          continue;
        }
        duration = inputDuration * 60; 
        break;
      }

      // Check available doctors
      availableDoctors = hospital.getAvailableDoctors(appointmentDateTime, duration);

      if (availableDoctors.isEmpty) {
        warning("\n** There are no doctors available at this time. Try another date/time. **\n");
      }
    }

    print("\n** Available Doctors **\n");
    for (int i = 0; i < availableDoctors.length; i++) {
      print('${i + 1}. ${availableDoctors[i].name}');
    }

    do {
      stdout.write('\n- Select Doctor No: ');
      final selectedDoctor = stdin.readLineSync()?.trim() ?? '';
      if (selectedDoctor.isEmpty || selectedDoctor.toLowerCase() == 'q') {
        warning("** Invalid selection **\n");
        return;
      }

      final index = int.tryParse(selectedDoctor);
      if (index == null || index < 1 || index > availableDoctors.length) {
        warning("** Invalid number. Try again. **\n");
        continue;
      }

      doctorId = availableDoctors[index - 1].staffId;
      break;
    } while (true);

    while (true) {
      stdout.write('- Reason: ');
      final inputReason = stdin.readLineSync()?.trim() ?? '';
      if (inputReason.isEmpty) {
        warning("\n** Reason cannot be empty **\n");
        continue;
      }
      reason = inputReason;
      break;
    }

    while (true) {
      stdout.write('- Doctor Notes (optional): ');
      final inputNote = stdin.readLineSync()?.trim() ?? '';
      doctorNote = inputNote; // can be empty
      break;
    }

    final appointment = hospital.createAppointment(
      patientId: patientId,
      doctorId: doctorId,
      appointmentDateTime: appointmentDateTime,
      duration: duration,
      reason: reason,
      status: AppointmentStatus.scheduled,
      doctorNotes: doctorNote,
    );

    hospital.addAppointment(appointment);
    final doctor = hospital.doctors[doctorId];
    doctor?.bookSlot(appointmentDateTime, duration);

    success("\n** Appointment created successfully **");
    pressEnterToContinue();
  }

  void createAppointmentSelectPatient() {
    patientConsole?.viewPatient();
    print("\n** select patient by No to create appointmen **");

    final patientEntries = hospital.getPatientEntries();
    if (patientEntries.isEmpty) {
      print("\n** No Patient yet **\n");
      pressEnterToContinue();
      return;
    }

    while (true) {
      stdout.write('\nEnter Patient by NO (or q to quit): ');
      final input = stdin.readLineSync()?.trim();
      if (input == null || input.toLowerCase() == 'q') return;

      final index = int.tryParse(input);
      if (index == null || index < 1 || index > patientEntries.length) {
        print("\n** Invalid selection. Try again. **\n");
        continue;
      }
      final selectPatient = patientEntries[index - 1];
      print("\n ** Create Appointment For ${selectPatient.value.fullName}");
      createAppointment(selectPatient.key);
      clearScreen();
      patientConsole?.viewPatient();
      print("\n** select patient by No to create appointment **");
    }
  }

  void updateAppointment() {
    final List<MapEntry<String, Appointment>> appointmentList = hospital
        .getAppointmentEntries();

    do {
      viewAppointment();
      print("\n ** Select a appointment to update **");
      stdout.write('\nEnter your Choice (or q to quit): ');
      String input = stdin.readLineSync() ?? '';
      if (input.trim().isEmpty) {
        warning("\n** Input cannot be empty. **\n");
      } else if (input.toLowerCase() == 'q') {
        clearScreen();
        startAppointmentConsole();
        break;
      } else {
        try {
          final int parseInput = int.parse(input);
          if (parseInput > 0 || parseInput <= appointmentList.length) {
            clearScreen();
            appointmentDetail(appointmentList, parseInput);
          } else {
            warning(
              '\n** Please enter a valid input (refer to table No. for input range) **\n',
            );
          }
        } catch (e) {
          warning('\n** Invalid input. Please enter a number or q to quit. **\n');
        }
      }
    } while (true);
  }

  void appointmentDetail(
    List<MapEntry<String, Appointment>> appointmentList,
    int input,
  ) {
    final MapEntry<String, Appointment> selectAppointment =
        appointmentList[input - 1];
    bool stillUpdate = true;
    String updateInput;
    do {
      print('** Appointment\'s information **');

      final headers = [
        'No',
        'Appointment DateTime',
        'Duration',
        'Reason',
        'Status',
        'DoctorNote',
      ];

      final row = [
        input,
        selectAppointment.value.appointmentDateTime.toLocal().toString().split(
          '.',
        )[0],
        selectAppointment.value.duration,
        selectAppointment.value.reason,
        selectAppointment.value.appointmentStatus.name,
        selectAppointment.value.doctorNotes ?? 'null',
      ];

      final table = Table(header: headers);
      table.add(row);
      print(table);

      print("\n-- Select any field to update --\n");
      print('1. Duration');
      print('2. Reason');
      print('3. Appointment\'s Status');
      print('4. Doctor Notes');
      print('0. Exit update mode to main update page');

      stdout.write('\nEnter your choice: ');
      updateInput = stdin.readLineSync() ?? '';
      switch (updateInput.trim()) {
        case '1':
          updateDuration(selectAppointment);
          break;
        case '2':
          updateReason(selectAppointment);
          break;
        case '3':
          updateStatus(selectAppointment);
          break;
        case '4':
          updateNote(selectAppointment);
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

  void updateDuration(MapEntry<String, Appointment> selectAppointment) {
    clearScreen();
    print("\n-- Update Duration (in hours) --\n");
    print("** Current Duration: ${selectAppointment.value.duration} hours");

    do {
      stdout.write("\nEnter new Duration (hours): ");
      String? input = stdin.readLineSync();

      if (input == null || input.trim().isEmpty) {
        warning("\n** Input can't be empty. **\n");
        continue;
      }

      int? newDuration = int.tryParse(input.trim());
      if (newDuration == null) {
        print("\n** Please enter a valid integer number. **\n");
        continue;
      }

      String? message = selectAppointment.value.updateDduration(newDuration);
      if (message != null) {
        warning("\n** $message **\n");
        continue;
      }

      success('\n** Duration updated successfully! **\n');
      pressEnterToContinue(text: "Press enter to view updated information");
      break;
    } while (true);
  }

  void updateReason(MapEntry<String, Appointment> selectAppointment) {
    clearScreen();
    print("\n-- Update Reason --\n");
    print("** Current Reason: ${selectAppointment.value.reason}");

    do {
      stdout.write("\nEnter new Reason: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        warning("\n** Input can't be empty. **\n");
        continue;
      }

      String? message = selectAppointment.value.updateReason(input);
      if (message != null) {
        warning("\n** $message **\n");
        continue;
      }
      success('\n** Reason is updated! **\n');
      pressEnterToContinue(text: "Press enter to view updated information");
      break;
    } while (true);
  }

  void updateNote(MapEntry<String, Appointment> selectAppointment) {
    clearScreen();
    print("\n-- Update Doctor's Note --\n");
    print("** Current Note: ${selectAppointment.value.doctorNotes}");

    do {
      stdout.write("\nEnter new Note: ");
      String input = stdin.readLineSync() ?? '';

      if (input.trim().isEmpty) {
        warning("\n** Input can't be empty. **\n");
        continue;
      }

      String? message = selectAppointment.value.updateNote(input);
      if (message != null) {
        warning("\n** $message **\n");
        continue;
      }
      success('\n** Note is updated! **\n');
      pressEnterToContinue(text: "Press enter to view updated information");
      break;
    } while (true);
  }

  void updateStatus(MapEntry<String, Appointment> selectAppointment) {
    clearScreen();
    print("\n-- Update Appointment Status --\n");
    print(
      "** Current Status: ${selectAppointment.value.appointmentStatus.name} **",
    );

    print("Choose new status:");
    print("1. Scheduled");
    print("2. Completed");
    print("3. Canceled");
    print("0. Cancel the update");

    do {
      stdout.write("\nEnter your choice: ");
      String? input = stdin.readLineSync();

      if (input == null || input.trim().isEmpty || input == '0') {
        warning("\n** Update cancelled. **\n");
        break;
      }

      AppointmentStatus? newStatus;

      switch (input.trim()) {
        case '1':
          newStatus = AppointmentStatus.scheduled;
          break;
        case '2':
          newStatus = AppointmentStatus.completed;
          break;
        case '3':
          newStatus = AppointmentStatus.cancel;
          break;
        default:
          print("\n** Invalid choice, try again. **\n");
          continue;
      }

      String? message = selectAppointment.value.updateStatus(newStatus, hospital);
      if (message != null) {
        print("\n** $message **\n");
        continue;
      }

      success('\n** Status updated successfully! **\n');
      pressEnterToContinue(text: "Press enter to view updated information");
      break;
    } while (true);
  }
}
