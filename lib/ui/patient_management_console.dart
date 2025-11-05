import 'dart:io';

import 'package:cli_table/cli_table.dart';
import 'package:hospital_management_system/domain/appointment.dart';
import 'package:hospital_management_system/domain/hospital.dart';
import 'package:hospital_management_system/main.dart';

class PatientConsole {
  final Hospital hospital;

  PatientConsole({required this.hospital});

  void startPatientConsole() {
    bool inSubmenu = true;
    do {
      clearScreen();
      print('--- patient management ---\n');
      print('1. View all Patient');
      print('2. Update Patient Informations');
      print('0. Exit ');

      String? userInput;
      stdout.write("Enter your choice: ");
      userInput = stdin.readLineSync();

      switch (userInput) {
        case '1':
          clearScreen();
          print("-- Patients --");
          viewPatient();
          pressEnterToContinue();
          break;
        case '2':
          pressEnterToContinue();
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
      'Status',
      'AppointmentIds',
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
        pat.status,
        pat.appointmentIds.join(','),
      ]);
      number++;
    });
    final table = Table(header: headers);
    table.addAll(rows);
    print(table);

    do {
      String? input;
      stdout.write(
        "Enter Appointment ID to view Detial or Press enter to go back:  ",
      );
      input = stdin.readLineSync()?.trim();

      if (input == null || input.isEmpty) {
        break;
      }

      if (!hospital.appointments.containsKey(input)) {
        print('The Appointment not found.');
        pressEnterToContinue();
        continue;
      }

      final appointment = hospital.appointments[input]!;
      viewAppointment(appointment);
      pressEnterToContinue();
      clearScreen();
      print(table);
    } while (true);
  }

  void viewAppointment(Appointment appointment) {
    print("\n-- View Appointment in Detail --\n");
    print("ID: ${appointment.appointmentId}\n");
    print("DoctorId: ${appointment.doctorId}");
    print("DateTime: ${appointment.appointmentDateTime}");
    print("Duration: ${appointment.duration}");
    print("Reason: ${appointment.reason}");
    print("AppointmentStatus: ${appointment.appointmentStatus}");
    print("DoctorNotes: ${appointment.doctorNotes}");
  }
}
