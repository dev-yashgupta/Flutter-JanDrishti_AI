class AppointmentModel {
  final String id;
  final String doctorId;
  final String doctorName;
  final String specialty;
  final String? doctorPhoto;
  final String date;
  final String time;
  final String status;
  final String? notes;
  final String? patientId;
  final String? patientName;

  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    this.doctorPhoto,
    required this.date,
    required this.time,
    required this.status,
    this.notes,
    this.patientId,
    this.patientName,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      doctorId: json['doctorId']?.toString() ?? json['doctor_id']?.toString() ?? '',
      doctorName: json['doctorName'] ?? json['doctor']?['name'] ?? 'Unknown Doctor',
      specialty: json['specialty'] ?? json['doctor']?['specialty'] ?? 'General',
      doctorPhoto: json['doctorPhoto'] ?? json['doctor']?['photo'],
      date: json['date'] ?? json['appointmentDate'] ?? '',
      time: json['time'] ?? json['appointmentTime'] ?? '',
      status: (json['status'] ?? 'pending').toString().toLowerCase(),
      notes: json['notes'] ?? json['reason'],
      patientId: json['patientId']?.toString() ?? json['patient_id']?.toString(),
      patientName: json['patientName'] ?? json['patient']?['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'specialty': specialty,
        'doctorPhoto': doctorPhoto,
        'date': date,
        'time': time,
        'status': status,
        'notes': notes,
        'patientId': patientId,
        'patientName': patientName,
      };

  bool get isUpcoming {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final appointmentDate = DateTime.parse(date);
      final appDay = DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day);
      return (appDay.isAfter(today) || appDay.isAtSameMomentAs(today)) &&
          status != 'cancelled' &&
          status != 'completed';
    } catch (_) {
      return status != 'cancelled' && status != 'completed';
    }
  }

  bool get isPast {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final appointmentDate = DateTime.parse(date);
      final appDay = DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day);
      return appDay.isBefore(today) ||
          status == 'completed' ||
          status == 'cancelled';
    } catch (_) {
      return true;
    }
  }
}

