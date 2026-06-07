import 'package:flutter/material.dart';
import 'package:flutter2/auth/cubit/auth_cubit.dart';
import 'package:flutter2/categories/bloc/category_bloc.dart';
import 'package:flutter2/categories/repository/category_repository.dart';
import 'package:flutter2/categories/view/category_view.dart';
import 'package:flutter2/core/theme/theme_cubit.dart';
import 'package:flutter2/counter/cubit/counter_cubit.dart';
import 'package:flutter2/counter/view/counter_page.dart';
import 'package:flutter2/delete_account/bloc/delete_account_bloc.dart';
import 'package:flutter2/delete_account/repository/delete_account_repository.dart';
import 'package:flutter2/delete_account/view/delete_account_view.dart';
import 'package:flutter2/home/view/home_page.dart';
import 'package:flutter2/login/bloc/login_bloc.dart';
import 'package:flutter2/login/repository/login_repository.dart';
import 'package:flutter2/login/view/login_page.dart';
import 'package:flutter2/posts/bloc/post_bloc.dart';
import 'package:flutter2/posts/bloc/post_event.dart';
import 'package:flutter2/posts/view/posts_page.dart';
import 'package:flutter2/products/bloc/product_bloc.dart';
import 'package:flutter2/products/repository/product_repository.dart';
import 'package:flutter2/products/view/product_view.dart';
import 'package:flutter2/profile/bloc/profile_bloc.dart';
import 'package:flutter2/profile/repository/profile_repository.dart';
import 'package:flutter2/profile/view/profile_edit.dart';
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

    final client = http.Client();

    return MultiRepositoryProvider(
      providers: [

        RepositoryProvider(
          create: (_) => LoginRepository(
            httpClient: client,
          ),
        ),

        RepositoryProvider(
          create: (_) => RegisterRepository(
            httpClient: client,
          ),
        ),

        RepositoryProvider(
          create: (_) => ProfileRepository(
            httpClient: client,
          ),
        ),

        RepositoryProvider(
          create: (_) => DeleteAccountRepository(
            httpClient: client,
          ),
        ),

        RepositoryProvider(
          create: (_) => CategoryRepository(
            httpClient: client,
          ),
        ),

        RepositoryProvider(
          create: (_) => ProductRepository(
            httpClient: client,
          ),
        ),
      ],

      child: MultiBlocProvider(
        providers: [

          BlocProvider(
            create: (_) => CounterCubit(),
          ),

          BlocProvider(
            create: (_) =>
                PostBloc(httpClient: client)
                  ..add(PostFetched()),
          ),

          BlocProvider(
            create: (_) => ThemeCubit(),
          ),

          BlocProvider(
            create: (_) => AuthCubit(),
          ),

          BlocProvider(
            create: (context) => LoginBloc(
              loginRepository:
                  context.read<LoginRepository>(),
            ),
          ),

          BlocProvider(
            create: (context) => RegisterBloc(
              registerRepository:
                  context.read<RegisterRepository>(),
            ),
          ),

          BlocProvider(
            create: (context) => ProfileBloc(
              profileRepository:
                  context.read<ProfileRepository>(),
            ),
          ),

          BlocProvider(
            create: (context) => DeleteAccountBloc(
              deleteAccountRepository:
                  context.read<DeleteAccountRepository>(),
            ),
          ),

          BlocProvider(
            create: (context) {

              final token =
                  context.read<AuthCubit>().state.token ?? '';

              return CategoryBloc(
                context.read<CategoryRepository>(),
              )..add(
                  GetCategoryEvent(
                    token: token,
                  ),
                );
            },
          ),

          BlocProvider(
            create: (context) => ProductBloc(
              context.read<ProductRepository>(),
            ),
          ),
        ],

        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, state) {

            return MaterialApp(
              debugShowCheckedModeBanner: false,

              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: state,

              initialRoute: '/login',

              routes: {

                '/home': (_) =>
                    const HomePage(),

                '/counter': (_) =>
                    const CounterPage(),

                '/posts': (_) =>
                    const PostsPage(),

                '/login': (_) =>
                    const LoginPage(),

                '/register': (_) =>
                    const RegisterPage(),

                '/profile': (_) =>
                    const ProfilePage(),

                '/update-profile': (_) =>
                    const ProfileEdit(),

                '/delete-account': (_) =>
                    const DeleteAccountView(),

                '/categories': (_) =>
                    const CategoryView(),

                '/products': (_) =>
                    const ProductView(),
              },
            );
          },
        ),
      ),
    );
  }
}