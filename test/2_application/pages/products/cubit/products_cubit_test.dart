import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_entity.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/failures/failures.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/usecases/product_usecases.dart';
import 'package:sprout_mobile_exam_serrano/2_application/core/error_messages.dart';
import 'package:sprout_mobile_exam_serrano/2_application/pages/products/cubit/products_cubit.dart';
import 'package:test/test.dart';

class MockProductUseCases extends Mock implements ProductUseCases {}

void main() {
  late MockProductUseCases mockProductUseCases;
  late List<ProductEntity> mockProducts;

  setUp(() {
    mockProductUseCases = MockProductUseCases();
    mockProducts = [
      const ProductEntity(
        id: 1,
        title: 'iPhone 9',
        price: 549,
        discountPercentage: 12.96,
        stock: 94,
        thumbnail: 'https://cdn.dummyjson.com/product-images/1/thumbnail.jpg',
      ),
      const ProductEntity(
        id: 2,
        title: 'iPhone X',
        price: 899,
        discountPercentage: 12.96,
        stock: 34,
        thumbnail: 'https://cdn.dummyjson.com/product-images/2/thumbnail.jpg',
      ),
    ];
  });

  group('ProductsCubit', () {
    test('fetch fetches products and emits ProductsStateLoaded on success',
        () async {
      when(() => mockProductUseCases.getProducts('0')).thenAnswer(
        (_) => Future.value(
          Right<Failure, List<ProductEntity>>(
            mockProducts,
          ),
        ),
      );

      final cubit = ProductsCubit(productUseCases: mockProductUseCases);

      await cubit.fetch();

      expect(cubit.state, ProductsStateLoaded(product: mockProducts));
    });

    test(
        'fetchMore fetches more products, merges with existing ones,'
        ' and emits ProductsStateLoaded', () async {
      when(() => mockProductUseCases.getProducts('0')).thenAnswer(
        (_) => Future.value(
          Right<Failure, List<ProductEntity>>(mockProducts),
        ),
      );
      final cubit = ProductsCubit(productUseCases: mockProductUseCases);
      await cubit.fetch();

      final newProducts = [
        const ProductEntity(
          id: 3,
          title: 'Samsung Universe 9',
          price: 1249,
          discountPercentage: 15.46,
          stock: 36,
          thumbnail: 'https://cdn.dummyjson.com/product-images/3/thumbnail.jpg',
        ),
      ];
      when(() => mockProductUseCases.getProducts('1')).thenAnswer(
        (_) => Future.value(
          Right<Failure, List<ProductEntity>>(newProducts),
        ),
      );

      await cubit.fetchMore(1);

      final expectedMergedProducts = [
        ...mockProducts,
        ...newProducts,
      ];
      expect(cubit.state, ProductsStateLoaded(product: expectedMergedProducts));
    });

    group('should throw when fetch() is called', () {
      test('and a ServerFailure occurs', () async {
        when(() => mockProductUseCases.getProducts('0')).thenAnswer(
          (_) => Future.value(
            Left<Failure, List<ProductEntity>>(
              ServerFailure(),
            ),
          ),
        );

        final cubit = ProductsCubit(productUseCases: mockProductUseCases);

        await cubit.fetch();

        expect(
          cubit.state,
          const ProductsStateError(message: serverFailureMessage),
        );
      });

      test('and a GeneralFailure occurs', () async {
        when(() => mockProductUseCases.getProducts('0')).thenAnswer(
          (_) => Future.value(
            Left<Failure, List<ProductEntity>>(
              GeneralFailure(),
            ),
          ),
        );

        final cubit = ProductsCubit(productUseCases: mockProductUseCases);

        await cubit.fetch();

        expect(
          cubit.state,
          const ProductsStateError(message: generalFailureMessage),
        );
      });
    });

    group('should throw when fetchMore() is called ', () {
      test('and a ServerFailure occurs', () async {
        when(() => mockProductUseCases.getProducts('0')).thenAnswer(
          (_) => Future.value(
            Right<Failure, List<ProductEntity>>(mockProducts),
          ),
        );
        final cubit = ProductsCubit(productUseCases: mockProductUseCases);
        await cubit.fetch();

        when(() => mockProductUseCases.getProducts('1')).thenAnswer(
          (_) => Future.value(
            Left<Failure, List<ProductEntity>>(
              ServerFailure(),
            ),
          ),
        );

        await cubit.fetchMore(1);

        expect(
          cubit.state,
          const ProductsStateError(message: serverFailureMessage),
        );
      });

      test('and a GeneralFailure occurs', () async {
        when(() => mockProductUseCases.getProducts('0')).thenAnswer(
          (_) => Future.value(
            Right<Failure, List<ProductEntity>>(mockProducts),
          ),
        );
        final cubit = ProductsCubit(productUseCases: mockProductUseCases);
        await cubit.fetch();

        when(() => mockProductUseCases.getProducts('1')).thenAnswer(
          (_) => Future.value(
            Left<Failure, List<ProductEntity>>(
              GeneralFailure(),
            ),
          ),
        );

        await cubit.fetchMore(1);

        expect(
          cubit.state,
          const ProductsStateError(message: generalFailureMessage),
        );
      });
    });
  });
}
