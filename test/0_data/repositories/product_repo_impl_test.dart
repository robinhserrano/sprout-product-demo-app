import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sprout_mobile_exam_serrano/0_data/datasources/product_remote_datasource.dart';
import 'package:sprout_mobile_exam_serrano/0_data/exceptions/exceptions.dart';
import 'package:sprout_mobile_exam_serrano/0_data/models/product_details_model.dart';
import 'package:sprout_mobile_exam_serrano/0_data/models/product_model.dart';
import 'package:sprout_mobile_exam_serrano/0_data/repositories/product_repo_impl.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_details_entity.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_entity.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/failures/failures.dart';
import 'package:test/test.dart';

class MockProductRemoteDatasource extends Mock
    implements ProductRemoteDatasourceImpl {}

void main() {
  group('ProductRepoImpl - getPaginatedProductsFromDataSource', () {
    group('should return List<ProductEntity>', () {
      test(
        'when ProductRemoteDatasource returns a List<ProductModel>',
        () async {
          final mockProductRemoteDatasource = MockProductRemoteDatasource();
          final productRepoImplUnderTest = ProductRepoImpl(
            productRemoteDatasource: mockProductRemoteDatasource,
          );

          when(
            () => mockProductRemoteDatasource.getPaginatedProductsFromApi('0'),
          ).thenAnswer(
            (_) => Future.value([
              const ProductModel(
                id: 1,
                title: 'iPhone 9',
                price: 549,
                discountPercentage: 12.96,
                stock: 94,
                thumbnail:
                    'https://cdn.dummyjson.com/product-images/1/thumbnail.jpg',
              ),
            ]),
          );

          final result = await productRepoImplUnderTest
              .getPaginatedProductsFromDataSource('0');

          expect(result.isLeft(), false);
          expect(result.isRight(), true);
          verify(
            () => mockProductRemoteDatasource.getPaginatedProductsFromApi('0'),
          ).called(1);
          verifyNoMoreInteractions(mockProductRemoteDatasource);
        },
      );
    });

    group('should return left with', () {
      test(
        'a ServerFailure when a ServerException occurs',
        () async {
          final mockProductRemoteDatasource = MockProductRemoteDatasource();
          final productRepoImplUnderTest = ProductRepoImpl(
            productRemoteDatasource: mockProductRemoteDatasource,
          );

          when(
            () => mockProductRemoteDatasource.getPaginatedProductsFromApi('0'),
          ).thenThrow(ServerException());

          final result = await productRepoImplUnderTest
              .getPaginatedProductsFromDataSource('0');

          expect(result.isLeft(), true);
          expect(result.isRight(), false);
          expect(result, Left<Failure, List<ProductEntity>>(ServerFailure()));
        },
      );

      test(
        'a GeneralFailure on all other Exceptions',
        () async {
          final mockProductRemoteDatasource = MockProductRemoteDatasource();
          final productRepoImplUnderTest = ProductRepoImpl(
            productRemoteDatasource: mockProductRemoteDatasource,
          );

          when(
            () => mockProductRemoteDatasource.getPaginatedProductsFromApi('0'),
          ).thenThrow(TypeError());

          final result = await productRepoImplUnderTest
              .getPaginatedProductsFromDataSource('0');

          expect(result.isLeft(), true);
          expect(result.isRight(), false);
          expect(result, Left<Failure, List<ProductEntity>>(GeneralFailure()));
        },
      );
    });
  });

  group('ProductRepoImpl - getProductFromDataSource', () {
    group('should return ProductDetailsEntity', () {
      test(
        'when ProductRemoteDatasource returns a ProductDetailsModel',
        () async {
          final mockProductRemoteDatasource = MockProductRemoteDatasource();
          final productRepoImplUnderTest = ProductRepoImpl(
            productRemoteDatasource: mockProductRemoteDatasource,
          );

          when(
            () => mockProductRemoteDatasource.getProductFromApi('1'),
          ).thenAnswer(
            (_) => Future.value(
              const ProductDetailsModel(
                id: 1,
                title: 'iPhone 9',
                description: 'An apple mobile which is nothing like apple',
                price: 549,
                discountPercentage: 12.96,
                rating: 4.69,
                stock: 94,
                brand: 'Apple',
                category: 'smartphones',
                thumbnail:
                    'https://cdn.dummyjson.com/product-images/1/thumbnail.jpg',
                images: [
                  'https://cdn.dummyjson.com/product-images/1/1.jpg',
                ],
              ),
            ),
          );

          final result =
              await productRepoImplUnderTest.getProductFromDataSource('1');

          expect(result.isLeft(), false);
          expect(result.isRight(), true);
          expect(
            result,
            const Right<Failure, ProductDetailsEntity>(
              ProductDetailsEntity(
                id: 1,
                title: 'iPhone 9',
                description: 'An apple mobile which is nothing like apple',
                price: 549,
                discountPercentage: 12.96,
                rating: 4.69,
                stock: 94,
                brand: 'Apple',
                category: 'smartphones',
                thumbnail:
                    'https://cdn.dummyjson.com/product-images/1/thumbnail.jpg',
                images: [
                  'https://cdn.dummyjson.com/product-images/1/1.jpg',
                ],
              ),
            ),
          );

          verify(
            () => mockProductRemoteDatasource.getProductFromApi('1'),
          ).called(1);
          verifyNoMoreInteractions(mockProductRemoteDatasource);
        },
      );
    });

    group('should return left with', () {
      test(
        'a ServerFailure when a ServerException occurs',
        () async {
          final mockProductRemoteDatasource = MockProductRemoteDatasource();
          final productRepoImplUnderTest = ProductRepoImpl(
            productRemoteDatasource: mockProductRemoteDatasource,
          );

          when(
            () => mockProductRemoteDatasource.getProductFromApi('1'),
          ).thenThrow(ServerException());

          final result =
              await productRepoImplUnderTest.getProductFromDataSource('1');

          expect(result.isLeft(), true);
          expect(result.isRight(), false);
          expect(result, Left<Failure, List<ProductEntity>>(ServerFailure()));
        },
      );

      test(
        'a GeneralFailure on all other Exceptions',
        () async {
          final mockProductRemoteDatasource = MockProductRemoteDatasource();
          final productRepoImplUnderTest = ProductRepoImpl(
            productRemoteDatasource: mockProductRemoteDatasource,
          );

          when(
            () => mockProductRemoteDatasource.getProductFromApi('1'),
          ).thenThrow(TypeError());

          final result =
              await productRepoImplUnderTest.getProductFromDataSource('1');

          expect(result.isLeft(), true);
          expect(result.isRight(), false);
          expect(result, Left<Failure, List<ProductEntity>>(GeneralFailure()));
        },
      );
    });
  });
}
