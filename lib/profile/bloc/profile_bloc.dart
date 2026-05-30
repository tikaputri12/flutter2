import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter2/profile/model/profile_model.dart';
import 'package:flutter2/profile/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<ProfileEvent>(_onProfileEvent);
  }
  Future<void> _onProfileEvent(
    ProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final ProfileModel profile = await profileRepository.getprofile(
        token: (event as LoadProfile).token,
      );

      emit(ProfileSuccess(profile: profile));
    } catch (e) {
      emit(ProfileFailure(message: e.toString()));
    }
  }
}
