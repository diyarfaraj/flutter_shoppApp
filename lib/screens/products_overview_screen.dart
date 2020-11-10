import 'package:flutter/material.dart';
import 'package:shoppApp/widgets/products_grid.dart';
import '../widgets/products_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text('My ShoppApp'),
      ),
      body: ProductsGrid(),
    );
    return scaffold;
  }
}
