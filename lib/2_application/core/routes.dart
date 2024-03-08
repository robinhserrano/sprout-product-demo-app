import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sprout_mobile_exam_serrano/2_application/pages/product_details/product_details_page.dart';
import 'package:sprout_mobile_exam_serrano/2_application/pages/products/products_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

const String _basePath = '';

final routes = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '$_basePath/${ProductsPage.name}',
  routes: [
    GoRoute(
      name: ProductsPage.name,
      path: ProductsPage.path,
      builder: (context, state) {
        return const ProductsPageWrapperProvider();
      },
    ),
    GoRoute(
      name: ProductDetailsPage.name,
      path: ProductDetailsPage.path,
      builder: (context, state) {
        return ProductDetailsPageWrapperProvider(
          productId: state.pathParameters['productId']!,
        );
      },
    ),
  ],
);
