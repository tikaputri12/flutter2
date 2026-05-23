import 'package:flutter/material.dart';
import 'package:flutter2/core/theme/theme_cubit.dart';
import 'package:flutter2/core/widgets/app_drawer.dart';
import 'package:flutter2/counter/cubit/counter_cubit.dart';
import 'package:flutter2/counter/cubit/counter_state.dart';
import 'package:flutter2/login/bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
            icon: const Icon(Icons.brightness_6),
          ),
        ],
      ),
      drawer: const AppDrawer(), // tambah koma + const
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state is LoginSuccess) {
                    final user = state.login.data!.user;

                    return Column(
                      children: [
                        Text(
                          'Welcome ${user?.username}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),

                        const SizedBox(height: 8),

                        Text(user?.email ?? '-'),
                      ],
                    );
                  }

                  return const Text('User belum login');
                },
              ),
            
            
            BlocBuilder<CounterCubit, CounterState>(
              builder: (context, state) {
                return Text(
                  'Counter Value: ${state.counter}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            BlocSelector<CounterCubit, CounterState, bool>(
              selector: (state) => state.isEven,
              builder: (context, isEven) {
                return Text(isEven ? "Genap" : "Ganjil");
              },
            ),
          ],
        ),
      ),
    );
  }
}
