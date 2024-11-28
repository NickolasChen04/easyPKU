import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class Appointment {
  final String id;
  final String doctorName;
  final String doctorId;
  final String userId;
  final String category;
  final String status;
  final DateTime date;
  final String day;
  final String time;
  final String doctorProfile;

  Appointment({
    required this.id,
    required this.doctorName,
    required this.doctorId,
    required this.userId,
    required this.category,
    required this.status,
    required this.date,
    required this.day,
    required this.time,
    required this.doctorProfile,
  });

  // Generate appointment ID method
  static String generateAppointmentId(String category, DateTime date) {
    // Get first 3 letters of category uppercase
    String prefix = category.substring(0, 3).toUpperCase();
    
    // Get date in DDMM format
    String dateStr = "${date.day.toString().padLeft(2,'0')}${date.month.toString().padLeft(2,'0')}";
    
    // Get sequential number from Firestore timestamp
    String sequence = DateTime.now().millisecondsSinceEpoch.toString().substring(9, 12);
    
    // Combine all parts: e.g. GEN2711001
    return "$prefix$dateStr$sequence";
  }

  // Factory constructor for creating new appointments
  factory Appointment.create({
    required String doctorName,
    required String doctorId,
    required String userId,
    required String category,
    required DateTime date,
    required String day,
    required String time,
    required String doctorProfile,
  }) {
    final id = generateAppointmentId(category, date);
    
    return Appointment(
      id: id,
      doctorName: doctorName,
      doctorId: doctorId,
      userId: userId,
      category: category,
      status: 'upcoming',
      date: date,
      day: day,
      time: time,
      doctorProfile: doctorProfile,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctorName': doctorName,
      'doctorId': doctorId,
      'userId': userId,
      'category': category,
      'status': status,
      'date': date,
      'day': day,
      'time': time,
      'doctorProfile': doctorProfile,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] ?? '',
      doctorName: map['doctorName'] ?? '',
      doctorId: map['doctorId'] ?? '',
      userId: map['userId'] ?? '',
      category: map['category'] ?? '',
      status: map['status'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      day: map['day'] ?? '',
      time: map['time'] ?? '',
      doctorProfile: map['doctorProfile'] ?? '',
    );
  }

  // Add getters for formatted strings if needed
  String get appointmentId => id;
  String get formattedDate => "${date.day}/${date.month}/${date.year}";
}