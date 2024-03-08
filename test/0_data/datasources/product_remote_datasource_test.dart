import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sprout_mobile_exam_serrano/0_data/datasources/product_remote_datasource.dart';
import 'package:sprout_mobile_exam_serrano/0_data/exceptions/exceptions.dart';
import 'package:sprout_mobile_exam_serrano/0_data/models/product_model.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements Dio {}

void main() {
  group('ProductRemoteDatasource', () {
    group('should return List of ProductModel', () {
      test('when Client response was 200 and has valid data', () async {
        final mockClient = MockClient();
        final productRemoteDatasourceUnderTest =
            ProductRemoteDatasourceImpl(client: mockClient);

        final mockResponse = <String, dynamic>{
          'products': [
            {
              'id': 1,
              'title': 'iPhone 9',
              'price': 549,
              'thumbnail':
                  'https://cdn.dummyjson.com/product-images/1/thumbnail.jpg',
              'stock': 94,
              'discountPercentage': 12.96,
            },
          ],
        };
        {
          when(
            () => mockClient.get<Map<String, dynamic>>(
              any(),
              options: any(named: 'options'),
            ),
          ).thenAnswer(
            (_) async => Response<Map<String, dynamic>>(
              data: mockResponse,
              statusCode: 200,
              requestOptions: RequestOptions(),
            ),
          );

          final result = await productRemoteDatasourceUnderTest
              .getPaginatedProductsFromApi('0');

          expect(result, [
            const ProductModel(
              id: 1,
              title: 'iPhone 9',
              price: 549,
              thumbnail:
                  'https://cdn.dummyjson.com/product-images/1/thumbnail.jpg',
              stock: 94,
              discountPercentage: 12.96,
            ),
          ]);
        }
      });
    });

    group('should throw', () {
      test('a ServerException when Client response was not 200', () {
        final mockClient = MockClient();
        final productRemoteDatasourceUnderTest =
            ProductRemoteDatasourceImpl(client: mockClient);

        when(
          () => mockClient.get<Map<String, dynamic>>(
            any(),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            statusCode: 404,
            requestOptions: RequestOptions(),
          ),
        );

        expect(
          productRemoteDatasourceUnderTest.getPaginatedProductsFromApi('0'),
          throwsA(isA<ServerException>()),
        );
      });

      test('a Type Error when Client response was 200 and has no valid data',
          () async {
        final mockClient = MockClient();
        final productRemoteDatasourceUnderTest =
            ProductRemoteDatasourceImpl(client: mockClient);

        final mockResponse = <String, dynamic>{
          'products': '',
        };
        {
          when(
            () => mockClient.get<Map<String, dynamic>>(
              any(),
              options: any(named: 'options'),
            ),
          ).thenAnswer(
            (_) async => Response<Map<String, dynamic>>(
              data: mockResponse,
              statusCode: 200,
              requestOptions: RequestOptions(),
            ),
          );

          expect(
            () => productRemoteDatasourceUnderTest
                .getPaginatedProductsFromApi('0'),
            throwsA(isA<TypeError>()),
          );
        }
      });
    });
  });
}
