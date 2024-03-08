import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_details_entity.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/failures/failures.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/usecases/product_details_usecases.dart';
import 'package:sprout_mobile_exam_serrano/2_application/core/error_messages.dart';
part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsCubitState> {
  ProductDetailsCubit({required this.productDetailsUseCases})
      : super(const ProductDetailsInitial());

  final ProductDetailsUseCases productDetailsUseCases;

  Future<void> fetch(String productId) async {
    emit(const ProductDetailsStateLoading());
    final failureOrAdvice = await productDetailsUseCases.getProduct(productId);
    failureOrAdvice.fold(
      (failure) => emit(
        ProductDetailsStateError(message: _mapFailureToMessage(failure)),
      ),
      (product) => emit(ProductDetailsStateLoaded(product: product)),
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
