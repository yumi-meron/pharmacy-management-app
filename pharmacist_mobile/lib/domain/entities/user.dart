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
  List<Object> get props => [id,name, phoneNumber, role, pharmacyId];
}
