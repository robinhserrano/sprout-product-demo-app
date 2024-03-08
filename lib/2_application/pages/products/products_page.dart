import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprout_mobile_exam_serrano/2_application/pages/products/cubit/products_cubit.dart';
import 'package:sprout_mobile_exam_serrano/2_application/pages/products/views/product_page_error.dart';
import 'package:sprout_mobile_exam_serrano/2_application/pages/products/views/product_page_loaded.dart';
import 'package:sprout_mobile_exam_serrano/2_application/pages/products/views/product_page_loading.dart';
import 'package:sprout_mobile_exam_serrano/injection.dart';

class ProductsPageWrapperProvider extends StatelessWidget {
  const ProductsPageWrapperProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductsCubit>(),
      child: const ProductsPage(),
    );
  }
}

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  static const name = 'products';
  static const path = '/products';

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xfff1f0f5),
      appBar: AppBar(
        title: const Text(
          'Home',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ProductsCubit, ProductsCubitState>(
                builder: (context, state) {
                  if (state is ProductsStateLoading) {
                    return const ProductPageLoading();
                  } else if (state is ProductsStateLoaded) {
                    return ProductsPageLoaded(
                      products: state.product,
                    );
                  } else if (state is ProductsStateError) {
                    return ProductPageError(
                      onRefresh: () => context.read<ProductsCubit>().fetch(),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
