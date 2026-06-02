import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter2/profile/model/profile_model.dart';
import 'package:flutter2/profile/repository/profile_repository.dart';


part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<LoadProfile>(_onProfileEvent);
    on<UpdateProfileEvent>(_onUpdateProfileEvent);
  }

  Future<void> _onProfileEvent(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final  profile = await profileRepository.getprofile(
        token: event.token,
      );
      emit(ProfileSuccess(profile: profile));
    } catch (e) {
      emit(ProfileFailure(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfileEvent(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileUpdating());

    try {
      await profileRepository.updateProfile(
        username: event.username,
        email: event.email,
      );
      emit(ProfileUpdateSuccess());
    } catch (e) {
      emit(ProfileFailure(message: e.toString()));
    }
  }
}