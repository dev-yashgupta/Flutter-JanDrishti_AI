class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? dateOfBirth;
  final String? bloodGroup;
  final String? photoUrl;
  final String? address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.dateOfBirth,
    this.bloodGroup,
    this.photoUrl,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? json['uid']?.toString() ?? '',
      name: json['name'] ?? json['displayName'] ?? 'User',
      email: json['email'] ?? '',
      phone: json['phone'] ?? json['phoneNumber'],
      dateOfBirth: json['dateOfBirth'] ?? json['dob'],
      bloodGroup: json['bloodGroup'] ?? json['blood_group'],
      photoUrl: json['photoUrl'] ?? json['photo_url'] ?? json['photoURL'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'dateOfBirth': dateOfBirth,
        'bloodGroup': bloodGroup,
        'photoUrl': photoUrl,
        'address': address,
      };

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? dateOfBirth,
    String? bloodGroup,
    String? photoUrl,
    String? address,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      photoUrl: photoUrl ?? this.photoUrl,
      address: address ?? this.address,
    );
  }
}

