import 'package:bloc/widgets/cart_page.dart';
import 'package:flutter/material.dart';

import 'cart_provider.dart';
import 'models/cart_item.dart';


class BlocCartPage extends StatelessWidget {
  BlocCartPage();

  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Cart"),
        ),
        body: StreamBuilder<List<CartItem>>(
            stream: cart.items,
            builder: (context, snapshot) {
              final items = snapshot.data;
              if (items == null || items.isEmpty) {
                return Center(
                    child: Text('Empty',
                        style: Theme.of(context).textTheme.headlineMedium));
              }

              return ListView(
                  children: items
                      .map((item) => ItemTile(item: item))
                      .toList());
            }));
  }
}