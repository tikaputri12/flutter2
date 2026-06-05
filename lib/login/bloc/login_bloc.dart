import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter2/login/models/login_model.dart';
import 'package:flutter2/login/repository/login_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';

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

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', login.data!.jwt);

      emit(LoginSuccess(login: login));
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
    }
  }
}