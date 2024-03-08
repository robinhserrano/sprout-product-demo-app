part of 'products_cubit.dart';

abstract class ProductsCubitState extends Equatable {
  const ProductsCubitState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsCubitState {
  const ProductsInitial();
}

class ProductsStateLoading extends ProductsCubitState {
  const ProductsStateLoading();
}

class ProductsStateLoaded extends ProductsCubitState {
  const ProductsStateLoaded({required this.product});
  final List<ProductEntity> product;

  @override
  List<Object> get props => [product];
}

class ProductsStateError extends ProductsCubitState {
  const ProductsStateError({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}
