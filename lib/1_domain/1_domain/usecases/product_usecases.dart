import 'package:dartz/dartz.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_entity.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/failures/failures.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/repositories/product_repo.dart';

class ProductUseCases {
  ProductUseCases({required this.productRepo});
  final ProductRepo productRepo;

  Future<Either<Failure, List<ProductEntity>>> getProducts(
    String skipNo,
  ) async {
    return productRepo.getPaginatedProductsFromDataSource(skipNo);
  }
}
