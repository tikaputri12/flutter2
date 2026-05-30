import 'package:flutter/material.dart';
import 'package:flutter2/login/bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// tambahkan import AuthCubit
import 'package:flutter2/auth/cubit/auth_cubit.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        // jika state login success
        if (state is LoginSuccess) {

          // simpan token global
          context.read<AuthCubit>().setLogin(
            token: state.login.data!.jwt,
          );

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(content: Text("Login succesful")),
          );

          Future.delayed(Duration(seconds: 1), () {
            Navigator.pushReplacementNamed(context, '/home');
          });
        }

        // jika state login failure
        if (state is LoginFailure) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Login Failed"),
              content: Text("Username atau password salah"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        // jika state sedang loading maka tampilkan Circular Progress Indicator
        if (state is LoginLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 32.0),

                    TextField(
                      controller: _username,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        hintText: "Input username",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: 8.0),

                    TextField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: "Input Password",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: 8.0),

                    SizedBox(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          print("login pressed");

                          context.read<LoginBloc>().add(
                            LoginSubmitted(
                              identifier: _username.text,
                              password: _password.text,
                            ),
                          );
                        },
                        child: Text("Login"),
                      ),
                    ),

                    SizedBox(height: 8.0),

                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        "Don't have an account? Register here",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}