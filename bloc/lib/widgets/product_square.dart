import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../models/product.dart';
import '../utils/is_dark.dart';

class ProductSquare extends StatelessWidget {
  final Product product;

  final GestureTapCallback onTap;

  ProductSquare({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: product.color,
      child: InkWell(
        onTap: onTap,
        child: Center(
            child: Text(
          product.name,
          style: TextStyle(
              color: isDark(product.color) ? Colors.white : Colors.black),
        )),
      ),
    );
  }
}
