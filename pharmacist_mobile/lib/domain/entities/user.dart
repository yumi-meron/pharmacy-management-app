import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String username;
  final String role;
  final int pharmacyId;
  final String picture;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    required this.pharmacyId,
    required this.picture,
  });

  @override
  List<Object> get props => [id,name, username, role, pharmacyId];
}
