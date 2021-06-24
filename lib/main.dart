import 'package:amar_shop/providers/auth.dart';
import 'package:amar_shop/screens/auth_screen.dart';
import 'package:amar_shop/screens/edit_product_screen.dart';
import 'package:amar_shop/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amar_shop/providers/cart.dart';
import 'package:amar_shop/providers/orders.dart';
import 'package:amar_shop/screens/product_detail_screen.dart';
import 'package:amar_shop/screens/cart_screen.dart';
import 'package:amar_shop/screens/orders_screen.dart';
import 'package:amar_shop/screens/product_overview_screen.dart';
import './providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) =>
              Products(Provider.of<Auth>(ctx, listen: false).token),
          update: (ctx, auth, prevProducts) =>
              Products(Provider.of<Auth>(ctx, listen: false).token),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(Provider.of<Auth>(ctx, listen: false).token),
          update: (ctx, auth, prevProducts) =>
              Orders(Provider.of<Auth>(ctx, listen: false).token),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Amar Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) => auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
