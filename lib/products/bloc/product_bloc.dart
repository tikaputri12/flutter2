import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter2/products/models/product_model.dart';
import 'package:flutter2/products/repository/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {

  final ProductRepository repository;

  ProductBloc(this.repository)
      : super(ProductInitial()) {

    // ================= GET PRODUCT =================
    on<GetProductEvent>((event, emit) async {

      emit(ProductLoading());

      try {

        final products =
            await repository.getProducts(
          token: event.token,
        );

        emit(ProductLoaded(products));

      } catch (e) {

        emit(ProductError(e.toString()));
      }
    });

    // ================= CREATE PRODUCT =================
    on<CreateProductEvent>((event, emit) async {

      try {

        await repository.createProduct(
          token: event.token,
          idCategory: event.idCategory,
          name: event.name,
          description: event.description,
          available: event.available,
          stock: event.stock,
          expired: event.expired,
        );

        // reload product
        final products =
            await repository.getProducts(
          token: event.token,
        );

        emit(ProductLoaded(products));

      } catch (e) {

        emit(ProductError(e.toString()));
      }
    });

    // ================= UPDATE PRODUCT =================
    on<UpdateProductEvent>((event, emit) async {

      try {

        await repository.updateProduct(
          token: event.token,
          id: event.id,
          name: event.name,
          description: event.description,
          idCategory: event.idCategory,
          stock: event.stock,
          available: event.available,
          expired: event.expired,
        );

        // reload product
        final products =
            await repository.getProducts(
          token: event.token,
        );

        emit(ProductLoaded(products));

      } catch (e) {

        emit(ProductError(e.toString()));
      }
    });

    // ================= DELETE PRODUCT =================
    on<DeleteProductEvent>((event, emit) async {

      try {

        await repository.deleteProduct(
          token: event.token,
          id: event.id,
        );

        // reload product
        final products =
            await repository.getProducts(
          token: event.token,
        );

        emit(ProductLoaded(products));

      } catch (e) {

        emit(ProductError(e.toString()));
      }
    });
  }
}