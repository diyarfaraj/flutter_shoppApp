import 'package:flutter/material.dart';
import 'package:shoppApp/providers/product_provider.dart';
import 'package:shoppApp/widgets/products_grid.dart';
import '../widgets/products_grid.dart';

import 'package:provider/provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text('My ShoppApp'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions option) {
              setState(() {
                if (option == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              )
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
    return scaffold;
  }
}
