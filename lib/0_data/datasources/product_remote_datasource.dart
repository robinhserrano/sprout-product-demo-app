import 'package:dio/dio.dart';
import 'package:sprout_mobile_exam_serrano/0_data/exceptions/exceptions.dart';
import 'package:sprout_mobile_exam_serrano/0_data/models/product_details_model.dart';
import 'package:sprout_mobile_exam_serrano/0_data/models/product_model.dart';

abstract class ProductRemoteDatasource {
  Future<List<ProductModel>> getPaginatedProductsFromApi(String skipNo);
  Future<ProductDetailsModel> getProductFromApi(String productId);
}

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  ProductRemoteDatasourceImpl({required this.client});
  final Dio client;

  @override
  Future<List<ProductModel>> getPaginatedProductsFromApi(String skipNo) async {
    final response = await client.get<Map<String, dynamic>>(
      'https://dummyjson.com/products?limit=10&skip=$skipNo&select=title,price,thumbnail,stock,discountPercentage',
      options: Options(headers: {'accept': 'application/json'}),
    );
    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      final products = (response.data!['products'] as List<dynamic>)
          .cast<Map<String, dynamic>>();

      final parsedProducts = products.map(ProductModel.fromJson).toList();

      return parsedProducts;
    }
  }

  @override
  Future<ProductDetailsModel> getProductFromApi(String productId) async {
    final response = await client.get<Map<String, dynamic>>(
      'https://dummyjson.com/products/$productId',
      options: Options(headers: {'accept': 'application/json'}),
    );
    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      final product = response.data!;

      final parsedProduct = ProductDetailsModel.fromJson(product);

      return parsedProduct;
    }
  }
}
