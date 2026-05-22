import 'package:equatable/equatable.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];

  String? get message => null;
}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final String message;
  const RegisterSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

final class RegisterFailure extends RegisterState {
  final String message;
  const RegisterFailure({required this.message});
  @override
  List<Object> get props => [message];
}