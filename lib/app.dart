import 'package:flutter/material.dart';
import 'package:flutter2/core/theme/theme_cubit.dart';
import 'package:flutter2/counter/cubit/counter_cubit.dart';
import 'package:flutter2/counter/view/counter_page.dart';
import 'package:flutter2/home/view/home_page.dart';
import 'package:flutter2/login/bloc/login_bloc.dart';
import 'package:flutter2/login/repository/login_repository.dart';
import 'package:flutter2/login/view/login_page.dart';
import 'package:flutter2/posts/bloc/post_bloc.dart';
import 'package:flutter2/posts/view/posts_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'posts/bloc/post_event.dart';

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => LoginRepository(httpClient: http.Client())),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CounterCubit()),
          BlocProvider(
            create: (_) =>
                PostBloc(httpClient: http.Client())..add(PostFetched()),
          ),
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (context) => LoginBloc(loginRepository: context.read<LoginRepository>())),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, state) {
            return MaterialApp(
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: context.watch<ThemeCubit>().state,
              debugShowCheckedModeBanner: false,
              initialRoute: '/login',
              routes: {
                '/home': (_) => const HomePage(),
                '/counter': (_) => const CounterPage(),
                '/posts': (_) => const PostsPage(),
                '/login': (_) => const LoginPage(),
              },
            );
          },
        ),
      ),
    );
  }
}
