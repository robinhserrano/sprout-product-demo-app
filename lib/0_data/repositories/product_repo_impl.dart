import 'package:dartz/dartz.dart';
import 'package:sprout_mobile_exam_serrano/0_data/datasources/product_remote_datasource.dart';
import 'package:sprout_mobile_exam_serrano/0_data/exceptions/exceptions.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_details_entity.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_entity.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/failures/failures.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/repositories/product_repo.dart';

class ProductRepoImpl implements ProductRepo {
  ProductRepoImpl({required this.productRemoteDatasource});
  final ProductRemoteDatasource productRemoteDatasource;

  @override
  Future<Either<Failure, List<ProductEntity>>>
      getPaginatedProductsFromDataSource(
    String skipNo,
  ) async {
    try {
      final result = await productRemoteDatasource.getPaginatedProductsFromApi(
        skipNo,
      );
      return right(
        result.map((productModel) => productModel.toEntity).toList(),
      );
    } on ServerException catch (_) {
      return left(ServerFailure());
    } catch (e) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, ProductDetailsEntity>> getProductFromDataSource(
    String productId,
  ) async {
    try {
      final result = await productRemoteDatasource.getProductFromApi(productId);
      return right(
        result.toEntity,
      );
    } on ServerException catch (_) {
      return left(ServerFailure());
    } catch (e) {
      return left(GeneralFailure());
    }
  }
}
