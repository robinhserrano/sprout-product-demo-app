import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sprout_mobile_exam_serrano/0_data/repositories/product_repo_impl.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_details_entity.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_entity.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/failures/failures.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/usecases/product_usecases.dart';
import 'package:test/test.dart';

class MockProductRepoImpl extends Mock implements ProductRepoImpl {}

void main() {
  group('ProductDetailsUsecases', () {
    group('should return ProductDetailsEntitiy', () {
      test('when ProductDetailsRepoImpl returns a ProductDetailsModel',
          () async {
        final mockProductDetailsRepoImpl = MockProductRepoImpl();
        final productDetailsUseCaseUnderTest =
            ProductUseCases(productRepo: mockProductDetailsRepoImpl);

        when(
          () => mockProductDetailsRepoImpl
              .getPaginatedProductsFromDataSource('0'),
        ).thenAnswer(
          (realInvocation) => Future.value(
            const Right(
              [
                ProductEntity(
                  id: 1,
                  title: 'iPhone 9',
                  price: 549,
                  discountPercentage: 12.96,
                  stock: 94,
                  thumbnail:
                      'https://cdn.dummyjson.com/product-images/1/thumbnail.jpg',
                ),
              ],
            ),
          ),
        );

        final result = await productDetailsUseCaseUnderTest.getProducts('0');

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        verify(
          () => mockProductDetailsRepoImpl
              .getPaginatedProductsFromDataSource('0'),
        ).called(
          1,
        );
        verifyNoMoreInteractions(mockProductDetailsRepoImpl);
      });
    });

    group('should return left with', () {
      test('a ServerFailure', () async {
        final mockProductDetailsRepoImpl = MockProductRepoImpl();
        final productDetailsUseCaseUnderTest =
            ProductUseCases(productRepo: mockProductDetailsRepoImpl);

        when(
          () => mockProductDetailsRepoImpl
              .getPaginatedProductsFromDataSource('0'),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Future.value(
              Left(ServerFailure()),
            ),
          ),
        );

        final result = await productDetailsUseCaseUnderTest.getProducts('0');

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, ProductDetailsEntity>(ServerFailure()));
        verify(
          () => mockProductDetailsRepoImpl
              .getPaginatedProductsFromDataSource('0'),
        ).called(
          1,
        );
        verifyNoMoreInteractions(mockProductDetailsRepoImpl);
      });

      test('a GeneralFailure', () async {
        final mockProductDetailsRepoImpl = MockProductRepoImpl();
        final productDetailsUseCaseUnderTest =
            ProductUseCases(productRepo: mockProductDetailsRepoImpl);

        when(
          () => mockProductDetailsRepoImpl
              .getPaginatedProductsFromDataSource('0'),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Future.value(
              Left(GeneralFailure()),
            ),
          ),
        );

        final result = await productDetailsUseCaseUnderTest.getProducts('0');

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, ProductDetailsEntity>(GeneralFailure()));
        verify(
          () => mockProductDetailsRepoImpl
              .getPaginatedProductsFromDataSource('0'),
        ).called(
          1,
        );
        verifyNoMoreInteractions(mockProductDetailsRepoImpl);
      });
    });
  });
}
