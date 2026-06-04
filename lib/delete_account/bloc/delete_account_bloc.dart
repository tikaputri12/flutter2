import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter2/delete_account/models/delete_account_model.dart';
import 'package:flutter2/delete_account/repository/delete_account_repository.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

class DeleteAccountBloc
    extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final DeleteAccountRepository deleteAccountRepository;

  DeleteAccountBloc({required this.deleteAccountRepository})
      : super(DeleteAccountInitial()) {
    on<DeleteAccountRequested>(_onDeleteAccountEvent);
  }

  Future<void> _onDeleteAccountEvent(
    DeleteAccountRequested event,
    Emitter<DeleteAccountState> emit,
  ) async {
    emit(DeleteAccountLoading());

    try {
      final deleteAccountModel =
          await deleteAccountRepository.deleteAccount(
        password: event.password,
      );

      emit(DeleteAccountSuccess(
        deleteAccountModel: deleteAccountModel,
      ));
    } catch (e) {
      emit(DeleteAccountFailure(error: e.toString()));
    }
  }
}