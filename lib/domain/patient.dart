import 'package:hospital_management_system/domain/enums.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Patient {
  final String _patientId;
  String fullName;
  Gender gender;
  DateTime dateOfBirth;
  String _phoneNumber;
  String address;
  String _emergencyContact;
  // List<String> _appointmentIds;

  Patient({
    String? patientId,
    required this.fullName,
    required this.gender,
    required this.dateOfBirth,
    required String phoneNumber,
    required this.address,
    required String emergencyContact
    // required List<String> appointmentIds,
  }) : _patientId = patientId ?? uuid.v4(),
       //  fullName = fullName,
       //  gender = gender,
       //  dateOfBirth = dateOfBirth,
       _emergencyContact = _validatePhoneNumber(emergencyContact),
       _phoneNumber = _validatePhoneNumber(phoneNumber);
      //  _appointmentIds = appointmentIds;

  String get phoneNumber => _phoneNumber;
  String get patientId => _patientId;
  String get emergencyContact => _emergencyContact;
  // List<String> get appointmentIds => _appointmentIds;

  // set

  // patient update information
  String? updateName(String newName) {
    // if (newName.trim().isEmpty) return "Name cannot be empty.";
    if (newName == fullName) return "New name is the same as current name.";
    fullName = newName;
    return null;
  }

  String? updateGender(Gender newGender) {
    if (newGender == gender) return "New gender is the same as current gender.";
    gender = newGender;
    return null;
  }

  String? updatePhoneNumber(String newNumber) {
    try {
      newNumber = _validatePhoneNumber(newNumber);
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }

    if (newNumber == _phoneNumber) return "New phone number is the same as current number.";
    _phoneNumber = newNumber;
    return null;
  }

  String? updateDateOfBirth(DateTime newDob) {
    if (newDob.isAfter(DateTime.now())) return "Date of Birth cannot be in the future.";

    if (newDob == dateOfBirth) return "New date is the same as current one.";

    dateOfBirth = newDob;
    return null;
  }

  String? updateAddress(String newAddress) {
    if (newAddress == address) return "New input address is the same as the current one.";
    address = newAddress;
    return null;
  }

  String? updateEmergencyContact (String newEmergencyContact) {
    if (newEmergencyContact == _emergencyContact) return "New input Emergency Contact is the same as the current Phone number.";
    _emergencyContact = newEmergencyContact;
    return null;
  }

  // validate phoneNumber
  static String _validatePhoneNumber(String value) {
    if (value.length < 9) {
      throw Exception('Invalid phone number: $value');
    }
    return value;
  }

}
