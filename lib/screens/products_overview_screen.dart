import 'package:flutter/material.dart';
import 'package:shoppApp/providers/cart.dart';
import 'package:shoppApp/screens/cart_screen.dart';
import 'package:shoppApp/widgets/app_drawer.dart';
import 'package:shoppApp/widgets/badge.dart';
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
          Consumer<Cart>(
            builder: (_, cartData, chld) => Badge(
              child: chld,
              value: cartData.itemCount.toString(),
              color: Color(0xFFFFFFFF),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              color: Color(0xFFFFFFFF),
            ),
          ),
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
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
    return scaffold;
  }
}
