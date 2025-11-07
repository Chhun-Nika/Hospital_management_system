# Hospital Management System (Dart)

A simple console-based **Hospital Management System** built in Dart. The system allows you to manage:

- Doctors and their working schedules  
- Nurses and their working schedules  
- Patients  
- Appointments  
- Booking slots for doctors  
- Viewing staff and their appointments
- Viewing doctor and their apppointments 

The project follows a **layered architecture** with `data`, `domain`, and `UI` folders for better organization.

---

## Features

1. **Doctor Management**
   - Create, view, and update their information
   - Add and remove shifts for doctors  
   - Display booked appointments  

2. **Nurse Management**
   - Create, view, and update their information 
   - Add and remove shifts for nurses  
   - Display nurses assisting doctors  

3. **Patient Management**
   - Create and update patients  
   - Display all Patients in the hospital
   - Diaplay appointments by selected patient

4. **Appointment Management**
   - Create appointments with available doctors  
   - Prevent overlapping appointments  
   - Display doctor-specific appointment schedules
   - Display all appointments in the hospital
   - Update appointment details and status  

5. **Console Interface**
   - View staff with working schedules and booked slots
   - View patients with their appointments information
   - Select a doctor to view all their appointments
   - User-friendly menus for navigation  

---

## Project Structure
```bash
lib/
  data/          # Repositories handling JSON data storage
  domain/        # Models like Doctor, Patient, Appointment, TimeSlot, etc.
  ui/            # Console interface classes
main.dart         # Entry point for the application
```
---

## Installation & Requirements

1. Install [Dart SDK](https://dart.dev/get-dart) (version >= 3.0 recommended).  
2. Clone the repository:

```bash
git clone <repository_url>
cd <project_folder>
```
3.	Get dependencies (if any):
```bash
dart pub get
```
4.	Run the application:
- cd to the lib folder and use this command
```bash
dart main.dart
```
- run manually: inside the main.dart file and click the run button

