import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprout_mobile_exam_serrano/2_application/pages/product_details/cubit/product_details_cubit.dart';
import 'package:sprout_mobile_exam_serrano/2_application/pages/product_details/views/product_details_page_loaded.dart';
import 'package:sprout_mobile_exam_serrano/2_application/pages/product_details/views/product_details_page_loading.dart';
import 'package:sprout_mobile_exam_serrano/2_application/pages/products/views/product_page_error.dart';
import 'package:sprout_mobile_exam_serrano/injection.dart';

class ProductDetailsPageWrapperProvider extends StatelessWidget {
  const ProductDetailsPageWrapperProvider({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductDetailsCubit>(),
      child: ProductDetailsPage(
        productId: productId,
      ),
    );
  }
}

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({required this.productId, super.key});

  final String productId;

  static const name = 'productDetails';
  static const path = '/productDetails/:productId';

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductDetailsCubit>().fetch(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ProductDetailsCubit, ProductDetailsCubitState>(
              builder: (context, state) {
                if (state is ProductDetailsStateLoading) {
                  return const ProductDetailsPageLoading();
                } else if (state is ProductDetailsStateLoaded) {
                  return ProductDetailsPageLoaded(
                    product: state.product,
                  );
                } else if (state is ProductDetailsStateError) {
                  return ProductPageError(
                    onRefresh: () => context.read<ProductDetailsCubit>().fetch(
                          widget.productId,
                        ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
