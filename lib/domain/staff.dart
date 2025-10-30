import 'package:hospital_management_system/domain/enums.dart';
import 'package:uuid/uuid.dart';


var uuid = Uuid();

abstract class Staff {
  final String _staffId;
  String _name;
  Role _role;
  String _phoneNumber;
  String _email;

  Staff({
    String? staffId,
    required String name,
    required Role role,
    required String phoneNumber,
    required String email,
  })  : _staffId = staffId ?? uuid.v4(),
        _name = name,
        _role = role,
        _phoneNumber = phoneNumber,
        _email = email;

  String get staffId => _staffId;
  String get name => _name;
  Role get role => _role;
  String get phoneNumber => _phoneNumber;
  String get email => _email;



}