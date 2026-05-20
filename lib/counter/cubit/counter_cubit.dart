import 'package:bloc/bloc.dart';
import 'package:flutter2/counter/cubit/counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterState(counter: 0, isEven: true));

  void increment() {
    final newCounter = state.counter +1;
    emit(CounterState(counter: newCounter, isEven: newCounter % 2 == 0));
  }

  void decrement(){
  final newCounter = state.counter -1;
    emit(CounterState(counter: newCounter, isEven: newCounter % 2 == 0));
  
  }
}
