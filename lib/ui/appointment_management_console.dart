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
    DateTime appointmentDateTime;
    int duration;
    String reason;
    String doctorNote;

    // display all existing doctor
    doctorConsole?.viewStaff();
    print("\n** Select Doctor for Appointment by No. **\n");
    do {
      stdout.write('- Doctor No: ');
      String selectedDoctor = stdin.readLineSync() ?? '';
      if (selectedDoctor.trim().isEmpty ||
          selectedDoctor.toLowerCase() == 'q') {
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

    while (true) {
      stdout.write('- DateTime (yyyy-mm-dd HH:MM): ');
      final inputDate = stdin.readLineSync()?.trim();
      try {
        if (inputDate == null || inputDate.isEmpty) throw FormatException();
        appointmentDateTime = DateTime.parse(inputDate.replaceAll(' ', 'T'));
        break;
      } catch (e) {
        print("Invalid date format, try again.");
      }
    }

    while (true) {
      stdout.write('- Duration in hours: ');
      int inputDuration = stdin.readByteSync();
      if (inputDuration.isNegative) {
        warning("\n** Duration Cannot be Negative **\n");
      } else {
        duration = inputDuration * 60;
        break;
      }
    }

    while (true) {
      stdout.write('- Reason: ');
      String inputReason = stdin.readLineSync() ?? '';
      if (inputReason.trim().isEmpty) {
        warning("\n** Reason Cannot be Empty **\n");
      } else {
        reason = inputReason.trim();
        break;
      }
    }

    while (true) {
      stdout.write('- Doctor Notes: ');
      String inputNote = stdin.readLineSync() ?? '';
      if (inputNote.trim().isEmpty) {
        warning("\n** Name Cannot be Empty **");
      } else {
        doctorNote = inputNote;
        break;
      }
    }

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
    print("\n** Create Sucessfully **");
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
