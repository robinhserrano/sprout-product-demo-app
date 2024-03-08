part of 'product_details_cubit.dart';

abstract class ProductDetailsCubitState extends Equatable {
  const ProductDetailsCubitState();

  @override
  List<Object> get props => [];
}

class ProductDetailsInitial extends ProductDetailsCubitState {
  const ProductDetailsInitial();
}

class ProductDetailsStateLoading extends ProductDetailsCubitState {
  const ProductDetailsStateLoading();
}

class ProductDetailsStateLoaded extends ProductDetailsCubitState {
  const ProductDetailsStateLoaded({required this.product});
  final ProductDetailsEntity product;

  @override
  List<Object> get props => [product];
}

class ProductDetailsStateError extends ProductDetailsCubitState {
  const ProductDetailsStateError({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}
