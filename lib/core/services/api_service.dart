import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/appointment_model.dart';
import '../models/doctor_model.dart';
import '../models/user_model.dart';
import '../constants/app_strings.dart';

class ApiService {
  static const String baseUrl = AppStrings.baseUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, String>> _getHeaders() async {
    final token = await _auth.currentUser?.getIdToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> _get(String endpoint) async {
    final headers = await _getHeaders();
    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
  }

  Future<http.Response> _post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> _put(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> _delete(String endpoint) async {
    final headers = await _getHeaders();
    return http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
  }

  // ─── Appointments ───────────────────────────────────────────────────────────

  Future<List<AppointmentModel>> getAppointments() async {
    try {
      final response = await _get('/appointments');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data is List ? data : (data['appointments'] ?? data['data'] ?? []);
        return list.map((j) => AppointmentModel.fromJson(j)).toList();
      }
      return _getMockAppointments();
    } catch (_) {
      return _getMockAppointments();
    }
  }

  Future<bool> bookAppointment({
    required String doctorId,
    required String doctorName,
    required String specialty,
    required String date,
    required String time,
    String? notes,
  }) async {
    try {
      final response = await _post('/appointments', {
        'doctorId': doctorId,
        'doctorName': doctorName,
        'specialty': specialty,
        'date': date,
        'time': time,
        'notes': ?notes,
      });
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {
      // Simulate success for demo
      return true;
    }
  }

  Future<bool> cancelAppointment(String appointmentId) async {
    try {
      final response = await _put('/appointments/$appointmentId/cancel', {'status': 'cancelled'});
      if (response.statusCode == 200) return true;
      final delResponse = await _delete('/appointments/$appointmentId');
      return delResponse.statusCode == 200 || delResponse.statusCode == 204;
    } catch (_) {
      return true;
    }
  }

  // ─── Doctors ─────────────────────────────────────────────────────────────────

  Future<List<DoctorModel>> getDoctors({String? specialty}) async {
    try {
      final endpoint = specialty != null && specialty.isNotEmpty
          ? '/doctors?specialty=${Uri.encodeComponent(specialty)}'
          : '/doctors';
      final response = await _get(endpoint);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data is List ? data : (data['doctors'] ?? data['data'] ?? []);
        if (list.isNotEmpty) {
          return list.map((j) => DoctorModel.fromJson(j)).toList();
        }
      }
      return _getMockDoctors();
    } catch (_) {
      return _getMockDoctors();
    }
  }

  // ─── Profile ─────────────────────────────────────────────────────────────────

  Future<UserModel?> getProfile() async {
    try {
      final response = await _get('/profile');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data is Map ? data : (data['user'] ?? data));
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _put('/profile', data);
      return response.statusCode == 200;
    } catch (_) {
      return true;
    }
  }

  // ─── AI Chat ─────────────────────────────────────────────────────────────────

  Future<String> sendAiMessage(String message, List<Map<String, String>> history) async {
    try {
      final response = await _post('/ai/chat', {
        'message': message,
        'history': history,
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ??
            data['message'] ??
            data['reply'] ??
            data['content'] ??
            'I understand your concern. Please consult with a healthcare professional for personalized advice.';
      }
      return _generateLocalAiResponse(message);
    } catch (_) {
      return _generateLocalAiResponse(message);
    }
  }

  // ─── Mock Data ────────────────────────────────────────────────────────────────

  List<AppointmentModel> _getMockAppointments() {
    final now = DateTime.now();
    return [
      AppointmentModel(
        id: '1',
        doctorId: 'd1',
        doctorName: 'Dr. Priya Sharma',
        specialty: 'General Medicine',
        date: now.add(const Duration(days: 2)).toIso8601String().split('T')[0],
        time: '10:00 AM',
        status: 'confirmed',
      ),
      AppointmentModel(
        id: '2',
        doctorId: 'd2',
        doctorName: 'Dr. Rahul Mehta',
        specialty: 'Cardiology',
        date: now.add(const Duration(days: 5)).toIso8601String().split('T')[0],
        time: '02:30 PM',
        status: 'pending',
      ),
      AppointmentModel(
        id: '3',
        doctorId: 'd3',
        doctorName: 'Dr. Anita Patel',
        specialty: 'Dermatology',
        date: now.subtract(const Duration(days: 7)).toIso8601String().split('T')[0],
        time: '11:00 AM',
        status: 'completed',
      ),
    ];
  }

  List<DoctorModel> _getMockDoctors() {
    return [
      DoctorModel(
        id: 'd1',
        name: 'Dr. Priya Sharma',
        specialty: 'General Medicine',
        qualification: 'MBBS, MD',
        hospital: 'City Health Center',
        rating: 4.8,
        reviewCount: 124,
        experience: 10,
        bio: 'Experienced general physician with focus on preventive care.',
        availableSlots: ['09:00 AM', '10:00 AM', '11:00 AM', '02:00 PM', '03:00 PM'],
        availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Friday'],
      ),
      DoctorModel(
        id: 'd2',
        name: 'Dr. Rahul Mehta',
        specialty: 'Cardiology',
        qualification: 'MBBS, MD, DM',
        hospital: 'Heart Care Institute',
        rating: 4.9,
        reviewCount: 89,
        experience: 15,
        bio: 'Senior cardiologist specializing in interventional cardiology.',
        availableSlots: ['10:00 AM', '11:30 AM', '02:30 PM', '04:00 PM'],
        availableDays: ['Monday', 'Wednesday', 'Thursday', 'Saturday'],
      ),
      DoctorModel(
        id: 'd3',
        name: 'Dr. Anita Patel',
        specialty: 'Dermatology',
        qualification: 'MBBS, MD (Dermatology)',
        hospital: 'Skin & Care Clinic',
        rating: 4.7,
        reviewCount: 201,
        experience: 8,
        bio: 'Dermatologist specializing in cosmetic and medical dermatology.',
        availableSlots: ['09:30 AM', '11:00 AM', '01:00 PM', '03:30 PM'],
        availableDays: ['Tuesday', 'Thursday', 'Friday', 'Saturday'],
      ),
      DoctorModel(
        id: 'd4',
        name: 'Dr. Suresh Kumar',
        specialty: 'Orthopedics',
        qualification: 'MBBS, MS (Ortho)',
        hospital: 'Bone & Joint Hospital',
        rating: 4.6,
        reviewCount: 156,
        experience: 12,
        bio: 'Orthopedic surgeon with expertise in joint replacement.',
        availableSlots: ['08:00 AM', '09:00 AM', '02:00 PM', '04:00 PM'],
        availableDays: ['Monday', 'Tuesday', 'Friday'],
      ),
      DoctorModel(
        id: 'd5',
        name: 'Dr. Meena Krishnan',
        specialty: 'Pediatrics',
        qualification: 'MBBS, DCH, MD',
        hospital: 'Children\'s Health Center',
        rating: 4.9,
        reviewCount: 312,
        experience: 14,
        bio: 'Dedicated pediatrician providing comprehensive child healthcare.',
        availableSlots: ['09:00 AM', '10:30 AM', '12:00 PM', '03:00 PM'],
        availableDays: ['Monday', 'Wednesday', 'Thursday', 'Saturday'],
      ),
      DoctorModel(
        id: 'd6',
        name: 'Dr. Arun Nair',
        specialty: 'Neurology',
        qualification: 'MBBS, MD, DM (Neurology)',
        hospital: 'Brain & Spine Clinic',
        rating: 4.7,
        reviewCount: 78,
        experience: 11,
        bio: 'Neurologist specializing in epilepsy and headache disorders.',
        availableSlots: ['10:00 AM', '11:30 AM', '03:00 PM', '04:30 PM'],
        availableDays: ['Tuesday', 'Wednesday', 'Friday'],
      ),
    ];
  }

  String _generateLocalAiResponse(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('headache') || lower.contains('migraine')) {
      return 'Headaches can have many causes including stress, dehydration, or tension. I recommend staying hydrated, resting in a quiet dark room, and taking OTC pain relievers if needed. If headaches are severe or frequent, please consult a neurologist.';
    } else if (lower.contains('fever') || lower.contains('temperature')) {
      return 'For fever, rest and stay hydrated. You can take acetaminophen or ibuprofen to manage temperature. If fever exceeds 103°F (39.4°C) or persists for more than 3 days, please see a doctor immediately.';
    } else if (lower.contains('appointment') || lower.contains('book')) {
      return 'You can book an appointment through the Appointments section. Go to the Appointments tab and tap the "+" button to schedule a visit with a doctor.';
    } else if (lower.contains('doctor') || lower.contains('specialist')) {
      return 'You can find doctors on the Doctors tab. Browse by specialty, view ratings and experience, and book an appointment directly.';
    } else if (lower.contains('medicine') || lower.contains('medication') || lower.contains('drug')) {
      return 'For medication advice, please consult with one of our qualified doctors. I can help you book an appointment or answer general health questions. Never self-medicate without proper medical guidance.';
    } else if (lower.contains('diet') || lower.contains('nutrition') || lower.contains('eat')) {
      return 'A balanced diet is crucial for good health. Focus on fruits, vegetables, whole grains, lean proteins, and healthy fats. Stay hydrated with 8+ glasses of water daily. For personalized dietary advice, consult a nutritionist.';
    } else if (lower.contains('exercise') || lower.contains('workout') || lower.contains('fitness')) {
      return 'Regular exercise is beneficial for overall health. Aim for at least 150 minutes of moderate aerobic activity per week. Include strength training twice a week. Start gradually and consult a doctor before starting a new exercise program.';
    } else if (lower.contains('sleep') || lower.contains('insomnia')) {
      return 'Good sleep is essential for health. Aim for 7-9 hours per night. Maintain a consistent sleep schedule, avoid screens before bed, and create a comfortable sleep environment. If sleep problems persist, consult a doctor.';
    } else if (lower.contains('stress') || lower.contains('anxiety') || lower.contains('mental')) {
      return 'Mental health is as important as physical health. Practice stress management through meditation, deep breathing, or yoga. Regular exercise and social connections help too. If you\'re struggling, please reach out to a mental health professional.';
    } else {
      return 'Thank you for your health query. As your AI health assistant, I can provide general health information, but for personalized medical advice, please consult with one of our qualified doctors. Would you like me to help you book an appointment?';
    }
  }
}

