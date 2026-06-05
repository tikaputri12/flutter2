part of 'category_bloc.dart';

abstract class CategoryEvent {}

// GET
class GetCategoryEvent extends CategoryEvent {
  final String token;
  GetCategoryEvent({required this.token});
}

// CREATE
class CreateCategoryEvent extends CategoryEvent {
  final CategoryModel category;
  final String token;

  CreateCategoryEvent({
    required this.category,
    required this.token,
  });
}

// UPDATE
class UpdateCategoryEvent extends CategoryEvent {
  final int id;
  final CategoryModel category;
  final String token;

  UpdateCategoryEvent({
    required this.id,
    required this.category,
    required this.token,
  });
}

// DELETE
class DeleteCategoryEvent extends CategoryEvent {
  final int id;
  final String token;

  DeleteCategoryEvent({
    required this.id,
    required this.token,
  });
}