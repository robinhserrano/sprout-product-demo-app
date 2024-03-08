// ignore_for_file: inference_failure_on_function_invocation

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_details_entity.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/failures/failures.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/usecases/product_details_usecases.dart';
import 'package:sprout_mobile_exam_serrano/2_application/core/error_messages.dart';
import 'package:sprout_mobile_exam_serrano/2_application/pages/product_details/cubit/product_details_cubit.dart';
import 'package:test/scaffolding.dart';

class MockProductDetailUseCases extends Mock
    implements ProductDetailsUseCases {}

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
  group('ProductDetailsCubit', () {
    group(
      'should emit',
      () {
        final mockProductDetailUseCases = MockProductDetailUseCases();

        blocTest(
          'nothing when no method is called',
          build: () => ProductDetailsCubit(
            productDetailsUseCases: mockProductDetailUseCases,
          ),
          expect: () => const <ProductDetailsCubitState>[],
        );

        blocTest(
          '[ProductDetailsCubitStateLoading, ProductDetailsCubitStateLoaded]'
          ' when ProductDetailsCubitequested() is called',
          setUp: () =>
              when(() => mockProductDetailUseCases.getProduct('1')).thenAnswer(
            (invocation) => Future.value(
              Right<Failure, ProductDetailsEntity>(
                mockProductDetailsEntity,
              ),
            ),
          ),
          build: () => ProductDetailsCubit(
            productDetailsUseCases: mockProductDetailUseCases,
          ),
          act: (cubit) => cubit.fetch('1'),
          expect: () => <ProductDetailsCubitState>[
            const ProductDetailsStateLoading(),
            ProductDetailsStateLoaded(
              product: mockProductDetailsEntity,
            ),
          ],
        );

        group(
          '[ProductDetailsCubitStateLoading, ProductDetailsCubitStateError]'
          ' when ProductDetailsCubitequested() is called',
          () {
            blocTest(
              'and a ServerFailure occurs',
              setUp: () => when(() => mockProductDetailUseCases.getProduct('1'))
                  .thenAnswer(
                (invocation) => Future.value(
                  Left<Failure, ProductDetailsEntity>(
                    ServerFailure(),
                  ),
                ),
              ),
              build: () => ProductDetailsCubit(
                productDetailsUseCases: mockProductDetailUseCases,
              ),
              act: (cubit) => cubit.fetch('1'),
              expect: () => const <ProductDetailsCubitState>[
                ProductDetailsStateLoading(),
                ProductDetailsStateError(message: serverFailureMessage),
              ],
            );

            blocTest(
              'and a GeneralFailure occurs',
              setUp: () => when(() => mockProductDetailUseCases.getProduct('1'))
                  .thenAnswer(
                (invocation) => Future.value(
                  Left<Failure, ProductDetailsEntity>(
                    GeneralFailure(),
                  ),
                ),
              ),
              build: () => ProductDetailsCubit(
                productDetailsUseCases: mockProductDetailUseCases,
              ),
              act: (cubit) => cubit.fetch('1'),
              expect: () => const <ProductDetailsCubitState>[
                ProductDetailsStateLoading(),
                ProductDetailsStateError(message: generalFailureMessage),
              ],
            );
          },
        );
      },
    );
  });
}
