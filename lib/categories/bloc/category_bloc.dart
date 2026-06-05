import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter2/categories/models/category_model.dart';
import 'package:flutter2/categories/repository/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc(this.repository) : super(CategoryInitial()) {

    // READ
    on<GetCategoryEvent>((event, emit) async {
      emit(CategoryLoading());

      try {
        final data =
            await repository.getCategories(event.token);
        emit(CategoryLoaded(data));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    // CREATE
    on<CreateCategoryEvent>((event, emit) async {
      emit(CategoryLoading());

      try {
        await repository.createCategory(
          event.category,
          event.token,
        );

        final data =
            await repository.getCategories(event.token);
        emit(CategoryLoaded(data));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    // UPDATE
    on<UpdateCategoryEvent>((event, emit) async {
      emit(CategoryLoading());

      try {
        await repository.updateCategory(
          event.id,
          event.category,
          event.token,
        );

        final data =
            await repository.getCategories(event.token);
        emit(CategoryLoaded(data));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    // DELETE
    on<DeleteCategoryEvent>((event, emit) async {
      emit(CategoryLoading());

      try {
        await repository.deleteCategory(
          event.id,
          event.token,
        );

        final data =
            await repository.getCategories(event.token);
        emit(CategoryLoaded(data));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}