import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? emergencyPhoneNumber;

  const Patient({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.emergencyPhoneNumber,
  });

  @override
  List<Object?> get props => [id, fullName, phoneNumber];
}
