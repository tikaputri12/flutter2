import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  // LOGIN
  void setLogin({required String token}) {
    emit(state.copyWith(token: token, isLogin: true));
  }

  // LOGOUT
  void logout() {
    emit(const AuthState());
  }
}