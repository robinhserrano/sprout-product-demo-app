import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_details_entity.dart';
part 'product_details_model.freezed.dart';
part 'product_details_model.g.dart';

@freezed
class ProductDetailsModel with _$ProductDetailsModel {
  const factory ProductDetailsModel({
    required int id,
    required String title,
    required String description,
    required double price,
    required double discountPercentage,
    required double rating,
    required int stock,
    required String brand,
    required String category,
    required String thumbnail,
    required List<String> images,
  }) = _ProductDetailsModel;

  const ProductDetailsModel._();

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsModelFromJson(json);

  ProductDetailsEntity get toEntity => ProductDetailsEntity(
        id: id,
        title: title,
        description: description,
        price: price,
        discountPercentage: discountPercentage,
        rating: rating,
        thumbnail: thumbnail,
        stock: stock,
        brand: brand,
        category: category,
        images: images,
      );
}
