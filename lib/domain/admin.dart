import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/staff.dart';

class Admin extends Staff {
  Admin({required super.name, required super.email, required super.phoneNumber})
    : super(role: Role.admin);

}
