import 'package:flutter/material.dart';

class ProductDetailsPageLoading extends StatelessWidget {
  const ProductDetailsPageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xfffa455f)),
    );
  }
}
