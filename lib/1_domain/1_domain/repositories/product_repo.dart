import 'package:dartz/dartz.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_details_entity.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_entity.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/failures/failures.dart';

abstract class ProductRepo {
  Future<Either<Failure, List<ProductEntity>>>
      getPaginatedProductsFromDataSource(
    String skipNo,
  );
  Future<Either<Failure, ProductDetailsEntity>> getProductFromDataSource(
    String productId,
  );
}
