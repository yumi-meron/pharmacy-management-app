import 'package:equatable/equatable.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileUpdating extends ProfileState {}

class ProfileUpdated extends ProfileState {
  final User user;

  const ProfileUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileUpdateError extends ProfileState {
  final String message;

  const ProfileUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}
