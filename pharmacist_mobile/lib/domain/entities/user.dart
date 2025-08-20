import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;
  final String role;
  final String pharmacyId;
  final String picture;

  const User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.pharmacyId,
    required this.picture,
  });

  @override
  List<Object> get props => [id, name, phoneNumber, role, pharmacyId];

  /// Create a modified copy while keeping other fields the same.
  User copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? role,
    String? pharmacyId,
    String? picture,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      picture: picture ?? this.picture,
    );
  }
}
