import 'package:hospital_management_system/domain/enums.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Patient {
  final String _patientId;
  String _fullName;
  Gender _gender;
  DateTime _dateOfBirth;
  String _phoneNumber;
  String _address;
  String _emergencyContact;
  String _status;
  List<String> _appointmentIds;

  Patient({
    String? patientId,
    required String fullName,
    required Gender gender,
    required DateTime dateOfBirth,
    required String phoneNumber,
    required String address,
    required String emergencyContact,
    required String status,
    
  }) : _patientId = patientId ?? uuid.v4(),
       _fullName = fullName,
       _gender = gender,
       _dateOfBirth = dateOfBirth,
       _phoneNumber = phoneNumber,
       _address = address,
       _emergencyContact = emergencyContact,
       _status = status,
       _appointmentIds = [];

  String get patientId => _patientId;
  String get fullName => _fullName;
  Gender get gender => _gender;
  DateTime get dateOfBirth => _dateOfBirth;
  String get phoneNumber => _phoneNumber;
  String get address => _address;
  String get emergencyContact => _emergencyContact;
  String get status => _status;

}
