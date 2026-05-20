import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter2/login/models/login_model.dart';
import 'package:flutter2/login/repository/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,

    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final LoginModel login = await loginRepository.login(
        identifier: event.identifier,
        password: event.password,
      );

      emit(LoginSuccess(login: login));
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
    }
  }
}
