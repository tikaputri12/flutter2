part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class LoadProfile extends ProfileEvent{
  final String token;

  const LoadProfile({required this.token});
@override
  List<Object> get props => [token];
}