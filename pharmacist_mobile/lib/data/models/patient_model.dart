import '../../domain/entities/patient.dart';

class PatientModel extends Patient {
  const PatientModel({
    required String id,
    required String fullName,
    required String phoneNumber,
    required String emergencyPhoneNumber,
  }) : super(
          id: id,
          fullName: fullName,
          phoneNumber: phoneNumber,
          emergencyPhoneNumber: emergencyPhoneNumber,
        );

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      phoneNumber: json['phone_number'] as String,
      emergencyPhoneNumber: json['emergency_phone_number'] as String,
    );
  }

  Patient toEntity() => this;
}
