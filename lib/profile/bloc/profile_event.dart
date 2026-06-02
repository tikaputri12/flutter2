part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class LoadProfile extends ProfileEvent {
  final String token;

  const LoadProfile({required this.token});

  @override
  List<Object> get props => [token];
}

final class UpdateProfileEvent extends ProfileEvent {
  final String username;
  final String email;

  const UpdateProfileEvent({
    required this.username,
    required this.email,
  });

  @override
  List<Object> get props => [
        username,
        email,
      ];
}