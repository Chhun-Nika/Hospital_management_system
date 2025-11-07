// this class is used to create a working hours and the appointments hours for staff (doctor and nurse)
import 'package:hospital_management_system/domain/time_of_day.dart';

class TimeSlot {
  TimeOfDay startTime;
  TimeOfDay endTime;

  TimeSlot({required this.startTime, required this.endTime});

}