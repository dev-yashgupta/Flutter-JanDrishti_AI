class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String? qualification;
  final String? hospital;
  final String? photoUrl;
  final double rating;
  final int reviewCount;
  final int experience;
  final String? bio;
  final bool isAvailable;
  final List<String> availableDays;
  final List<String> availableSlots;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    this.qualification,
    this.hospital,
    this.photoUrl,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.experience = 0,
    this.bio,
    this.isAvailable = true,
    this.availableDays = const [],
    this.availableSlots = const [],
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    List<String> days = [];
    if (json['availableDays'] is List) {
      days = List<String>.from(json['availableDays']);
    }
    List<String> slots = [];
    if (json['availableSlots'] is List) {
      slots = List<String>.from(json['availableSlots']);
    }

    return DoctorModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? 'Dr. Unknown',
      specialty: json['specialty'] ?? json['specialization'] ?? 'General',
      qualification: json['qualification'] ?? json['qualifications'],
      hospital: json['hospital'] ?? json['clinic'],
      photoUrl: json['photoUrl'] ?? json['photo'] ?? json['image'],
      rating: (json['rating'] ?? 4.5).toDouble(),
      reviewCount: json['reviewCount'] ?? json['reviews'] ?? 0,
      experience: json['experience'] ?? json['yearsOfExperience'] ?? 0,
      bio: json['bio'] ?? json['description'],
      isAvailable: json['isAvailable'] ?? true,
      availableDays: days,
      availableSlots: slots,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'specialty': specialty,
        'qualification': qualification,
        'hospital': hospital,
        'photoUrl': photoUrl,
        'rating': rating,
        'reviewCount': reviewCount,
        'experience': experience,
        'bio': bio,
        'isAvailable': isAvailable,
        'availableDays': availableDays,
        'availableSlots': availableSlots,
      };
}

