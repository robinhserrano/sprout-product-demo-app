import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sprout_mobile_exam_serrano/0_data/repositories/product_repo_impl.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_details_entity.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/failures/failures.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/usecases/product_details_usecases.dart';
import 'package:test/test.dart';

class MockProductRepoImpl extends Mock implements ProductRepoImpl {}

void main() {
  late ProductDetailsEntity mockProductDetailsEntity;

  setUp(() {
    mockProductDetailsEntity = const ProductDetailsEntity(
      id: 1,
      title: 'iPhone 9',
      description: 'An apple mobile which is nothing like apple',
      price: 549,
      discountPercentage: 12.96,
      rating: 4.69,
      stock: 94,
      brand: 'Apple',
      category: 'smartphones',
      thumbnail: 'https://cdn.dummyjson.com/product-images/1/thumbnail.jpg',
      images: [
        'https://cdn.dummyjson.com/product-images/1/1.jpg',
      ],
    );
  });
  group('ProductDetailsUsecases', () {
    group('should return ProductDetailsEntitiy', () {
      test('when ProductDetailsRepoImpl returns a ProductDetailsModel',
          () async {
        final mockProductDetailsRepoImpl = MockProductRepoImpl();
        final productDetailsUseCaseUnderTest =
            ProductDetailsUseCases(productRepo: mockProductDetailsRepoImpl);

        when(() => mockProductDetailsRepoImpl.getProductFromDataSource('1'))
            .thenAnswer(
          (realInvocation) => Future.value(
            Right(mockProductDetailsEntity),
          ),
        );

        final result = await productDetailsUseCaseUnderTest.getProduct('1');

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
          result,
          Right<Failure, ProductDetailsEntity>(
            mockProductDetailsEntity,
          ),
        );
        verify(() => mockProductDetailsRepoImpl.getProductFromDataSource('1'))
            .called(
          1,
        );
        verifyNoMoreInteractions(mockProductDetailsRepoImpl);
      });
    });

    group('should return left with', () {
      test('a ServerFailure', () async {
        final mockProductDetailsRepoImpl = MockProductRepoImpl();
        final productDetailsUseCaseUnderTest =
            ProductDetailsUseCases(productRepo: mockProductDetailsRepoImpl);

        when(() => mockProductDetailsRepoImpl.getProductFromDataSource('1'))
            .thenAnswer(
          (realInvocation) => Future.value(
            Future.value(
              Left(ServerFailure()),
            ),
          ),
        );

        final result = await productDetailsUseCaseUnderTest.getProduct('1');

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, ProductDetailsEntity>(ServerFailure()));
        verify(() => mockProductDetailsRepoImpl.getProductFromDataSource('1'))
            .called(
          1,
        );
        verifyNoMoreInteractions(mockProductDetailsRepoImpl);
      });

      test('a GeneralFailure', () async {
        final mockProductDetailsRepoImpl = MockProductRepoImpl();
        final productDetailsUseCaseUnderTest =
            ProductDetailsUseCases(productRepo: mockProductDetailsRepoImpl);

        when(() => mockProductDetailsRepoImpl.getProductFromDataSource('1'))
            .thenAnswer(
          (realInvocation) => Future.value(
            Future.value(
              Left(GeneralFailure()),
            ),
          ),
        );

        final result = await productDetailsUseCaseUnderTest.getProduct('1');

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, ProductDetailsEntity>(GeneralFailure()));
        verify(() => mockProductDetailsRepoImpl.getProductFromDataSource('1'))
            .called(
          1,
        );
        verifyNoMoreInteractions(mockProductDetailsRepoImpl);
      });
    });
  });
}
