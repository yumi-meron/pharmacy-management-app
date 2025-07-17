import 'package:pharmacist_mobile/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.phoneNumber,
    required super.role,
    required super.pharmacyId,
    required super.picture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      role: json['role'],
      pharmacyId: json['pharmacy_id'],
      picture: json['picture'] 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'role': role,
      'pharmacy_id': pharmacyId,
      'picture': picture,
    };
  }
}
// This model class extends the User entity and provides methods to convert 