import 'dart:io';

import 'package:cli_table/cli_table.dart';
import 'package:hospital_management_system/domain/appointment.dart';
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
          clearScreen();
          print("-- Appointments --");
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
          print("-- Update Appointment --");
          pressEnterToContinue();
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

  // AI-generated : fucntion warning message
  void warning(String message) {
    // ANSI escape code for yellow text
    const yellow = '\x1B[33m';
    const reset = '\x1B[0m';
    print('\n$yellow WARNING: $message$reset');
  }

  void createAppointment(String patientId) {
  warning("All information must be filled in order to create Appointment.\n");
  late String doctorId;
  late DateTime appointmentDateTime;
  late int duration;
  late String reason;
  late String doctorNote;

  // Display all existing doctors
  doctorConsole?.viewStaff();
  print("\n** Select Doctor for Appointment by No. **\n");

  // Select doctor
  do {
    stdout.write('- Doctor No: ');
    String selectedDoctor = stdin.readLineSync()?.trim() ?? '';
    if (selectedDoctor.isEmpty || selectedDoctor.toLowerCase() == 'q') {
      print("** Invalid **\n");
      return;
    }

    final doctorEntries = hospital.getDoctorEntries();
    final index = int.tryParse(selectedDoctor);
    if (index == null || index < 1 || index > doctorEntries.length) {
      print("** Invalid number. Try again. **\n");
      continue;
    }

    doctorId = doctorEntries[index - 1].key;
    break;
  } while (true);

  // DateTime input
  while (true) {
    stdout.write('- DateTime (yyyy-mm-dd HH:MM): ');
    final inputDate = stdin.readLineSync()?.trim();
    if (inputDate == null || inputDate.isEmpty) {
      print("** Input cannot be empty. **\n");
      continue;
    }

    try {
      // Normalize input to ISO format
      appointmentDateTime = DateTime.parse(inputDate.replaceAll(' ', 'T'));

      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day).add(Duration(days: 1));

      if (!appointmentDateTime.isAfter(tomorrow.subtract(const Duration(seconds: 1)))) {
        print("** Appointment must be scheduled from tomorrow onwards. **\n");
        continue;
      }

      break; // valid
    } catch (e) {
      print("** Invalid date format. Use yyyy-mm-dd HH:MM **\n");
    }
  }

  // Duration input
  while (true) {
    stdout.write('- Duration in hours: ');
    String? input = stdin.readLineSync()?.trim();
    int? inputDuration = int.tryParse(input ?? '');
    if (inputDuration == null || inputDuration <= 0) {
      warning("** Duration must be a positive integer **\n");
      continue;
    }
    duration = inputDuration * 60;
    break;
  }

  // Reason
  while (true) {
    stdout.write('- Reason: ');
    String inputReason = stdin.readLineSync()?.trim() ?? '';
    if (inputReason.isEmpty) {
      warning("** Reason cannot be empty **\n");
      continue;
    }
    reason = inputReason;
    break;
  }

  // Doctor Notes
  while (true) {
    stdout.write('- Doctor Notes: ');
    String inputNote = stdin.readLineSync()?.trim() ?? '';
    if (inputNote.isEmpty) {
      warning("** Doctor Notes cannot be empty **\n");
      continue;
    }
    doctorNote = inputNote;
    break;
  }

  // Create appointment
  final appointment = Appointment(
    patientId: patientId,
    doctorId: doctorId,
    dateTime: appointmentDateTime,
    duration: duration,
    reasons: reason,
    appointmentStatus: AppointmentStatus.scheduled,
    doctorNotes: doctorNote,
  );

  hospital.addAppointment(appointment);
  print("\n** Appointment Created Successfully **");
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
      print("\n** select patient by No to create appointmen **");
    }
  }
}
