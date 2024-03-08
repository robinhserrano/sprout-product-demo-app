import 'package:flutter/material.dart';

class ProductPageLoading extends StatelessWidget {
  const ProductPageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xfffa455f)),
    );
  }
}
