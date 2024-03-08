import 'package:freezed_annotation/freezed_annotation.dart';
part 'product_details_entity.freezed.dart';

@freezed
class ProductDetailsEntity with _$ProductDetailsEntity {
  const factory ProductDetailsEntity({
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
  }) = _ProductDetailsEntity;
}
