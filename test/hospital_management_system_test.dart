import 'package:hospital_management_system/data/appointment_repository.dart';
import 'package:hospital_management_system/data/doctor_repository.dart';
import 'package:hospital_management_system/data/hospital_repository.dart';
import 'package:hospital_management_system/data/nurse_repository.dart';
import 'package:hospital_management_system/data/patient_repository.dart';
import 'package:hospital_management_system/domain/enums.dart';
import 'package:hospital_management_system/domain/hospital.dart';
import 'package:hospital_management_system/domain/time_of_day.dart';
import 'package:hospital_management_system/domain/time_slot.dart';
import 'package:test/test.dart';

void main() {
  late Hospital hospital;
  late HospitalRepository hospitalRepository;

  setUpAll(() {
    // Initialize repositories
    final doctorRepo = DoctorRepository('lib/data/doctors.json');
    final patientRepo = PatientRepository('lib/data/patient.json');
    final appointmentRepo = AppointmentRepository('lib/data/appointment.json');
    final nurseRepo = NurseRepository('lib/data/nurses.json');

    hospitalRepository = HospitalRepository(
      doctorRepo: doctorRepo,
      patientRepo: patientRepo,
      appointmentRepo: appointmentRepo,
      nurseRepo: nurseRepo,
    );

    // Load all data once for all tests
    hospital = hospitalRepository.loadAll();
  });

  group('Hospital I/O', () {
    test('Load data from file', () {
      expect(hospital.doctors.isNotEmpty, true);
      expect(hospital.nurses.isNotEmpty, true);
      expect(hospital.patients.isNotEmpty, true);
      expect(hospital.appointments.isNotEmpty, true);
    });
  });

  group("Doctor management", () {
    test('Create doctor with valid data', () {
      final workingSchedule = <DayOfWeek, List<TimeSlot>>{
        DayOfWeek.monday: [
          TimeSlot(
            startTime: TimeOfDay(hour: 9, minute: 0),
            endTime: TimeOfDay(hour: 17, minute: 0),
          ),
        ],
      };

      final doctor = hospital.createDoctor(
        name: 'Dr. John',
        gender: Gender.male,
        phoneNumber: '0123456789',
        email: 'john@example.com',
        specialization: 'Cardiology',
        workingSchedule: workingSchedule,
      );

      expect(hospital.doctors.containsKey(doctor.staffId), isTrue);
      expect(doctor.name, 'Dr. John');
      expect(doctor.specialization, 'Cardiology');
    });
    test('Create doctor with invalid email should throw exception', () {
      final workingSchedule = <DayOfWeek, List<TimeSlot>>{};

      expect(
        () => hospital.createDoctor(
          name: 'Dr. InvalidEmail',
          gender: Gender.female,
          phoneNumber: '0123456789',
          email: 'invalid-email-format', // invalid
          specialization: 'Cardiology',
          workingSchedule: workingSchedule,
        ),
        throwsA(isA<Exception>()), // expects an Exception
      );
    });
    test('Create doctor with invalid phone number should throw exception', () {
      final workingSchedule = <DayOfWeek, List<TimeSlot>>{};

      expect(
        () => hospital.createDoctor(
          name: 'Dr. InvalidPhoneNum',
          gender: Gender.female,
          phoneNumber: '01234',
          email: 'doctor@gmail.com', // invalid
          specialization: 'Cardiology',
          workingSchedule: workingSchedule,
        ),
        throwsA(isA<Exception>()), // expects an Exception
      );
    });
  });

  group("Nurse Management", () {
    test('Create nurse with valid data', () {
      final workingSchedule = <DayOfWeek, List<TimeSlot>>{
        DayOfWeek.monday: [
          TimeSlot(
            startTime: TimeOfDay(hour: 9, minute: 0),
            endTime: TimeOfDay(hour: 17, minute: 0),
          ),
        ],
      };

      final nurse = hospital.createNurse(
        name: 'Alice',
        gender: Gender.female,
        phoneNumber: '0123456789',
        email: 'alice@example.com',
        workingSchedule: workingSchedule,
      );

      expect(hospital.nurses.containsKey(nurse.staffId), isTrue);
      expect(nurse.name, 'Alice');
    });
    test('Create nurse with invalid email should throw exception', () {
      final workingSchedule = <DayOfWeek, List<TimeSlot>>{};

      expect(
        () => hospital.createNurse(
          name: 'Bob',
          gender: Gender.male,
          phoneNumber: '0123456789',
          email: 'invalid-email',
          workingSchedule: workingSchedule,
        ),
        throwsA(isA<Exception>()),
      );
    });
    test('Create nurse with overlapping shifts should fail adding shift', () {
      final workingSchedule = <DayOfWeek, List<TimeSlot>>{
        DayOfWeek.tuesday: [
          TimeSlot(
            startTime: TimeOfDay(hour: 9, minute: 0),
            endTime: TimeOfDay(hour: 12, minute: 0),
          ),
        ],
      };

      final nurse = hospital.createNurse(
        name: 'Charlie',
        gender: Gender.other,
        phoneNumber: '0987654321',
        email: 'charlie@example.com',
        workingSchedule: workingSchedule,
      );

      // Attempt to add an overlapping shift on Tuesday
      final added = nurse.addShift(
        DayOfWeek.tuesday,
        TimeSlot(
          startTime: TimeOfDay(hour: 11, minute: 0),
          endTime: TimeOfDay(hour: 14, minute: 0),
        ),
      );

      expect(added, isFalse); // overlap, should not add
      expect(nurse.workingSchedule[DayOfWeek.tuesday]!.length, 1);
    });
    test('Add non-overlapping shift successfully', () {
      final workingSchedule = <DayOfWeek, List<TimeSlot>>{
        DayOfWeek.wednesday: [
          TimeSlot(
            startTime: TimeOfDay(hour: 8, minute: 0),
            endTime: TimeOfDay(hour: 12, minute: 0),
          ),
        ],
      };

      final nurse = hospital.createNurse(
        name: 'Diana',
        gender: Gender.female,
        phoneNumber: '0123456789',
        email: 'diana@example.com',
        workingSchedule: workingSchedule,
      );

      final added = nurse.addShift(
        DayOfWeek.wednesday,
        TimeSlot(
          startTime: TimeOfDay(hour: 13, minute: 0),
          endTime: TimeOfDay(hour: 17, minute: 0),
        ),
      );

      expect(added, isTrue);
      expect(nurse.workingSchedule[DayOfWeek.wednesday]!.length, 2);
    });
    test('Update nurse email and phone', () {
      final workingSchedule = <DayOfWeek, List<TimeSlot>>{};
      final nurse = hospital.createNurse(
        name: 'Eve',
        gender: Gender.female,
        phoneNumber: '0123456789',
        email: 'eve@example.com',
        workingSchedule: workingSchedule,
      );

      // update email
      final emailResult = nurse.updateEmail('new@example.com');
      expect(emailResult, isNull);
      expect(nurse.email, 'new@example.com');

      // update phone
      final phoneResult = nurse.updatePhoneNumber('0987654321');
      expect(phoneResult, isNull);
      expect(nurse.phoneNumber, '0987654321');
    });
  });

  group("Patient Management", () {
    test('Create patient with valid data', () {
      final patient = hospital.createPatient(
        name: 'John Doe',
        gender: Gender.male,
        dateOfBirth: DateTime(1990, 5, 20),
        phoneNumber: '0123456789',
        address: '123 Main Street',
        emergencyContact: '0987654321',
      );

      expect(hospital.patients.containsKey(patient.patientId), isTrue);
      expect(patient.fullName, 'John Doe');
      expect(patient.gender, Gender.male);
      expect(patient.phoneNumber, '0123456789');
      expect(patient.address, '123 Main Street');
      expect(patient.emergencyContact, '0987654321');
    });
    test('Update patient gender', () {
      final patient = hospital.createPatient(
        name: 'Sam Lee',
        gender: Gender.other,
        dateOfBirth: DateTime(2000, 1, 10),
        phoneNumber: '0123456789',
        address: '789 Oak Avenue',
        emergencyContact: '0987654321',
      );

      final result = patient.updateGender(Gender.male);
      expect(result, isNull);
      expect(patient.gender, Gender.male);

      final sameGenderResult = patient.updateGender(Gender.male);
      expect(sameGenderResult, 'New gender is the same as current gender.');
    });
    test('Update patient phone number with valid and invalid data', () {
      final patient = hospital.createPatient(
        name: 'Lily Chen',
        gender: Gender.female,
        dateOfBirth: DateTime(1985, 8, 25),
        phoneNumber: '0123456789',
        address: '101 Pine Street',
        emergencyContact: '0987654321',
      );

      // Valid update
      final result = patient.updatePhoneNumber('0987654321');
      expect(result, isNull);
      expect(patient.phoneNumber, '0987654321');

      // Updating with same number should return message
      final sameResult = patient.updatePhoneNumber('0987654321');
      expect(sameResult, 'New phone number is the same as current number.');

      // Invalid update
      final invalidResult = patient.updatePhoneNumber('0123');
      expect(invalidResult, 'Invalid phone number: 0123');
    });
  });
}
