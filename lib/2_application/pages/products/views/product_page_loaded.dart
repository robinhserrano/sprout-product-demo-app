import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_entity.dart';
import 'package:sprout_mobile_exam_serrano/2_application/pages/products/cubit/products_cubit.dart';
import 'package:sprout_mobile_exam_serrano/2_application/pages/products/widgets/product_card.dart';

class ProductsPageLoaded extends HookWidget {
  const ProductsPageLoaded({required this.products, super.key});

  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();
    final skipNo = useState(0);
    final controller = useScrollController();
    final isLoadingMore = useState(false);

    useEffect(
      () {
        controller.addListener(() async {
          final shouldFetchMore =
              controller.position.maxScrollExtent == controller.offset;

          if (shouldFetchMore) {
            isLoadingMore.value = true;
            await cubit.fetchMore(++skipNo.value);
            isLoadingMore.value = false;
          }
        });

        return null;
      },
      const [],
    );

    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No Events found.',
        ),
      );
    }

    return Scrollbar(
      controller: controller,
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              controller: controller,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
              ),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                return ProductCard(product: products[index]);
              },
            ),
          ),
          if (isLoadingMore.value) ...[
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ],
      ),
    );
  }
}
