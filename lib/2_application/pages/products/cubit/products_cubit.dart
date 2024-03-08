import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_entity.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/failures/failures.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/usecases/product_usecases.dart';
import 'package:sprout_mobile_exam_serrano/2_application/core/error_messages.dart';
part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsCubitState> {
  ProductsCubit({required this.productUseCases})
      : super(const ProductsStateLoading()) {
    fetch();
  }

  final ProductUseCases productUseCases;

  Future<void> fetch() async {
    final failureOrAdvice = await productUseCases.getProducts('0');
    failureOrAdvice.fold(
      (failure) =>
          emit(ProductsStateError(message: _mapFailureToMessage(failure))),
      (product) => emit(ProductsStateLoaded(product: product)),
    );
  }

  Future<void> fetchMore(int skipNo) async {
    final currentProducts = state is ProductsStateLoaded
        ? (state as ProductsStateLoaded).product
        // ignore: inference_failure_on_collection_literal
        : [];

    final failureOrAdvice = await productUseCases.getProducts(
      skipNo.toString(),
    );

    failureOrAdvice.fold(
      (failure) =>
          emit(ProductsStateError(message: _mapFailureToMessage(failure))),
      (newProduct) {
        if (currentProducts.isEmpty) {
          emit(ProductsStateLoaded(product: newProduct));
        } else {
          final mergedProducts = [
            ...currentProducts as List<ProductEntity>,
            ...newProduct,
          ];
          emit(ProductsStateLoaded(product: mergedProducts));
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return generalFailureMessage;
    }
  }
}
