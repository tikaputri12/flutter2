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

      drawer: const AppDrawer(),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            /// ================= USER =================
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginSuccess) {
                  final user = state.login.data!.user;

                  return Column(
                    children: [
                      Text(
                        'Welcome, ${user?.username ?? "-"}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        user?.email ?? '-',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.7),
                              letterSpacing: 0.3,
                            ),
                      ),
                    ],
                  );
                }

                return Text(
                  'User belum login',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                );
              },
            ),

            const SizedBox(height: 30),

            /// ================= COUNTER =================
            BlocBuilder<CounterCubit, CounterState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Text(
                      'Counter Value',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      '${state.counter}',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            /// ================= GENAP / GANJIL =================
            BlocSelector<CounterCubit, CounterState, bool>(
              selector: (state) => state.isEven,
              builder: (context, isEven) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isEven
                        ? Colors.green.withOpacity(0.15)
                        : Colors.orange.withOpacity(0.15),
                  ),
                  child: Text(
                    isEven ? "GENAP" : "GANJIL",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}