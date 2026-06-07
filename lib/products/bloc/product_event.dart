part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

// ================= GET PRODUCT =================
class GetProductEvent extends ProductEvent {
  final String token;

  const GetProductEvent({
    required this.token,
  });

  @override
  List<Object?> get props => [token];
}

// ================= CREATE PRODUCT =================
class CreateProductEvent extends ProductEvent {
  final String token;
  final int idCategory;
  final String name;
  final String description;
  final bool available;
  final int stock;
  final String? expired;

  const CreateProductEvent({
    required this.token,
    required this.idCategory,
    required this.name,
    required this.description,
    required this.available,
    required this.stock,
    this.expired,
  });

  @override
  List<Object?> get props => [
        token,
        idCategory,
        name,
        description,
        available,
        stock,
        expired,
      ];
}

// ================= UPDATE PRODUCT =================
class UpdateProductEvent extends ProductEvent {
  final String token;
  final int id;
  final String name;
  final String description;

  final int idCategory;
  final int stock;
  final bool available;
  final String? expired;

  const UpdateProductEvent({
    required this.token,
    required this.id,
    required this.name,
    required this.description,
    required this.idCategory,
    required this.stock,
    required this.available,
    this.expired,
  });

  @override
  List<Object?> get props => [
        token,
        id,
        name,
        description,
        idCategory,
        stock,
        available,
        expired,
      ];
}

// ================= DELETE PRODUCT =================
class DeleteProductEvent extends ProductEvent {
  final String token;
  final int id;

  const DeleteProductEvent({
    required this.token,
    required this.id,
  });

  @override
  List<Object?> get props => [
        token,
        id,
      ];
}