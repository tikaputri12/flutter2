part of 'delete_account_bloc.dart';

sealed class DeleteAccountEvent extends Equatable {
  const DeleteAccountEvent();

  @override
  List<Object> get props => [];
}

// EVENT: REQUEST DELETE ACCOUNT
final class DeleteAccountRequested extends DeleteAccountEvent {
  final String password;

  const DeleteAccountRequested({required this.password});

  @override
  List<Object> get props => [password];
}