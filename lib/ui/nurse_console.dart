import 'dart:io';

import 'package:hospital_management_system/main.dart';

class NurseConsole {
  void startNurseConsole() {
    bool inSubmenu = true;
    do {
      print('-- Nurse Management --');
      print('1. View all Nurses');
      print('2. Update Nurses Information');
      print('0. Exit to Staff Management');

      String? userInput;
      stdout.write("Enter your choice: ");
      userInput = stdin.readLineSync();

      switch (userInput) {
        case '1':
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
}
