import 'package:pharmacist_mobile/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.role,
    required super.pharmacyId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      role: json['role'],
      pharmacyId: json['pharmacy_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'role': role,
      'pharmacy_id': pharmacyId,
    };
  }
}
// This model class extends the User entity and provides methods to convert