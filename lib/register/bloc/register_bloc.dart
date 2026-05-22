import 'package:bloc/bloc.dart';
import 'package:flutter2/register/bloc/register_event.dart';
import 'package:flutter2/register/bloc/register_state.dart';
import 'package:flutter2/register/models/register_models.dart';
import 'package:flutter2/register/repository/register_repository.dart';


class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository registerRepository;
  RegisterBloc({required this.registerRepository}) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }
  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      final RegisterModel register = await registerRepository.register(
        email: event.email,
        username: event.username,

        password: event.password,
      );
      emit(RegisterSuccess(message: register.message));
    } catch (e) {
      emit(RegisterFailure(message: e.toString()));
    }
  }
}