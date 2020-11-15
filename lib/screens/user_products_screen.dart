import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppApp/providers/product_provider.dart';

class UserProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: null, //här är vi
          itemCount: productsData.items.length,
        ),
      ),
    );
  }
}
