import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/domain/usecases/user/update_profile_usecase.dart';
import 'package:pharmacist_mobile/presentation/blocs/user/user_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/user/user_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfile updateProfileUseCase;

  ProfileBloc({required this.updateProfileUseCase})
      : super(ProfileInitial()) {
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileUpdating());

    final result = await updateProfileUseCase(
      UpdateProfileParams(user: event.user, pictureFile: event.pictureFile),
    );

    result.fold(
      (failure) => emit(ProfileUpdateError(failure.message)),
      (updatedUser) => emit(ProfileUpdated(updatedUser)),
    );
  }
}
