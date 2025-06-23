import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String role;
  final int pharmacyId;
  

  const User({
    required this.id,
    required this.username,
    required this.role,
    required this.pharmacyId,

  });

  @override
  List<Object> get props => [id, username, role, pharmacyId];
}