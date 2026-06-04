part of 'delete_account_bloc.dart';

sealed class DeleteAccountState extends Equatable {
  const DeleteAccountState();

  @override
  List<Object> get props => [];
}

// INITIAL
final class DeleteAccountInitial extends DeleteAccountState {}

// LOADING
final class DeleteAccountLoading extends DeleteAccountState {}

// SUCCESS
final class DeleteAccountSuccess extends DeleteAccountState {
  final DeleteAccountModel deleteAccountModel;

  const DeleteAccountSuccess({required this.deleteAccountModel});

  @override
  List<Object> get props => [deleteAccountModel];
}

// FAILURE
final class DeleteAccountFailure extends DeleteAccountState {
  final String error;

  const DeleteAccountFailure({required this.error});

  @override
  List<Object> get props => [error];
}