import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_entity.dart';
part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required int id,
    required String title,
    required double price,
    required String thumbnail,
    required int stock,
    required double discountPercentage,
  }) = _ProductModel;

  const ProductModel._();

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  ProductEntity get toEntity => ProductEntity(
        id: id,
        title: title,
        price: price,
        thumbnail: thumbnail,
        stock: stock,
        discountPercentage: discountPercentage,
      );
}
