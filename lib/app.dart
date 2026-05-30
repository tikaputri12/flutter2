import 'package:flutter/material.dart';
import 'package:flutter2/auth/cubit/auth_cubit.dart';
import 'package:flutter2/core/theme/theme_cubit.dart';
import 'package:flutter2/counter/cubit/counter_cubit.dart';
import 'package:flutter2/counter/view/counter_page.dart';
import 'package:flutter2/home/view/home_page.dart';
import 'package:flutter2/login/bloc/login_bloc.dart';
import 'package:flutter2/login/repository/login_repository.dart';
import 'package:flutter2/login/view/login_page.dart';
import 'package:flutter2/posts/bloc/post_bloc.dart';
import 'package:flutter2/posts/bloc/post_event.dart';
import 'package:flutter2/posts/view/posts_page.dart';
import 'package:flutter2/profile/bloc/profile_bloc.dart';
import 'package:flutter2/profile/repository/profile_repository.dart';
import 'package:flutter2/profile/view/profile_page.dart';
import 'package:flutter2/register/bloc/register_bloc.dart';
import 'package:flutter2/register/repository/register_repository.dart';
import 'package:flutter2/register/view/register_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // LOGIN REPOSITORY
        RepositoryProvider(
          create: (_) => LoginRepository(httpClient: http.Client()),
        ),

        // REGISTER REPOSITORY
        RepositoryProvider(
          create: (_) => RegisterRepository(httpClient: http.Client()),
        ),

        // PROFILE REPOSITORY
        RepositoryProvider(
          create: (_) => ProfileRepository(httpClient: http.Client()),
        ),
      ],

      child: MultiBlocProvider(
        providers: [
          // COUNTER
          BlocProvider(create: (_) => CounterCubit()),

          // POSTS
          BlocProvider(
            create: (_) =>
                PostBloc(httpClient: http.Client())..add(PostFetched()),
          ),

          // THEME
          BlocProvider(create: (_) => ThemeCubit()),

          // AUTH CUBIT
          BlocProvider(create: (_) => AuthCubit()),

          // LOGIN BLOC
          BlocProvider(
            create: (context) =>
                LoginBloc(
                  loginRepository: context.read<LoginRepository>(),
                ),
          ),

          // REGISTER BLOC
          BlocProvider(
            create: (context) => RegisterBloc(
              registerRepository: context.read<RegisterRepository>(),
            ),
          ),

          // PROFILE BLOC
          BlocProvider(
            create: (context) => ProfileBloc(
              profileRepository: context.read<ProfileRepository>(),
            ),
          ),
        ],

        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,

              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),

              themeMode: context.watch<ThemeCubit>().state,

              initialRoute: '/login',

              routes: {
                '/home': (_) => const HomePage(),

                '/counter': (_) => const CounterPage(),

                '/posts': (_) => const PostsPage(),

                '/login': (_) => const LoginPage(),

                '/register': (_) => const RegisterPage(),

                '/profile': (_) => const ProfilePage(),
              },
            );
          },
        ),
      ),
    );
  }
}