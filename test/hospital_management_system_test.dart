import 'dart:math';

import 'package:hospital_management_system/domain/admin.dart';
import 'package:hospital_management_system/domain/doctor.dart';
import 'package:hospital_management_system/domain/enums.dart';
import 'package:test/test.dart';

void main() {
  late Admin admin1;

  setUp(() {
    admin1 = Admin(
      name: "nika",
      email: "nika@gmail.com",
      phoneNumber: "0123456789",
    );
  });

  group("Admin portal", () {
    group("Admin creates staffs", () {
      test("Create Doctor", () {
        final doctor1 = admin1.createDoctor(
          name: "Bob",
          email: "Bob@hospital.com",
          phoneNumber: "012444555",
          specialization: "Cardiology",
        );
        expect(doctor1.role, equals(Role.doctor));
      });

    });
  });
}
