part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final String? token;
  final bool isLogin;

  const AuthState({this.token, this.isLogin = false});

  AuthState copyWith({String? token, bool? isLogin}) {
    return AuthState(
      token: token ?? this.token,
      isLogin: isLogin ?? this.isLogin,
    );
  }

  @override
  List<Object?> get props => [token, isLogin];
}