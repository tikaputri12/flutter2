import 'package:flutter/material.dart';
import 'package:flutter2/core/theme/theme_cubit.dart';
import 'package:flutter2/core/widgets/app_drawer.dart';
import 'package:flutter2/counter/cubit/counter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/counter_cubit.dart';

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CounterCubit, CounterState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state.counter == 10) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Counter mencapai 10")));
        }
        // jika counter < 0, maka tampilkan alert dialog
        if (state.counter < 0) {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Warning"),
                content: Text("Counter Negatif!"),
              );
            },
          );
        }
      },
      child: Scaffold(
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
            children: [
              BlocBuilder<CounterCubit, CounterState>(
                builder: (context, state) {
                  return Text(
                    '${state.counter}',
                    style: const TextStyle(fontSize: 40),
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
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => context.read<CounterCubit>().increment(),
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () => context.read<CounterCubit>().decrement(),
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }
}
