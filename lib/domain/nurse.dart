import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/staff.dart';
import 'package:hospital_management_system/domain/time_slot.dart';

class Nurse extends Staff {
  String? _doctorId;

  // using named constructor in order to make the constructor private so it cannot be instantiated outside the class and other subclass 
  Nurse({
    String? id,
    required super.name,
    required super.gender,
    required super.phoneNumber,
    required super.email,
    String? doctorId,
    required super.workingSchedule,
  }) : _doctorId = doctorId,
       super(role: Role.nurse, staffId: id);

  String get doctorId => _doctorId ?? '';

  
}
