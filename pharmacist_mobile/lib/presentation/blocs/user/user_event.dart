import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileEvent extends ProfileEvent {
  final User user;
  final File? pictureFile; // optional new image file

  const UpdateProfileEvent({required this.user, this.pictureFile});

  @override
  List<Object?> get props => [user, pictureFile];
}
