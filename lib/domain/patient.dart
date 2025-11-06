import 'package:hospital_management_system/domain/enums.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Patient {
  final String _patientId;
  String fullName;
  Gender gender;
  DateTime dateOfBirth;
  String phoneNumber;
  String address;
  String emergencyContact;
  List<String> _appointmentIds;

  Patient({
    String? patientId,
    String? receptionistId,
    required String fullName,
    required Gender gender,
    required DateTime dateOfBirth,
    required String phoneNumber,
    required String address,
    required String emergencyContact,
    required List<String> appointmentIds,
  }) : _patientId = patientId ?? uuid.v4(),
       fullName = fullName,
       gender = gender,
       dateOfBirth = dateOfBirth,
       phoneNumber = phoneNumber,
       address = address,
       emergencyContact = emergencyContact,
       _appointmentIds = appointmentIds;

  String get patientId => _patientId;
  // String get fullName => fullName;
  // Gender get gender => gender;
  // DateTime get dateOfBirth => dateOfBirth;
  // String get phoneNumber => phoneNumber;
  // String get address => address;
  // String get emergencyContact => emergencyContact;
  List<String> get appointmentIds => _appointmentIds;
}
