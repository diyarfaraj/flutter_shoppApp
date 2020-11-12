import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppApp/providers/cart.dart';
import 'package:shoppApp/screens/cart_screen.dart';

import 'package:shoppApp/screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';
import './providers/product_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          accentColor: Colors.blueAccent,
          fontFamily: 'Lato',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductsOverviewScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
        },
      ),
    );
  }
}
