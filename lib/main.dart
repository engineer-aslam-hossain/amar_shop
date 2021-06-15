import 'package:amar_shop/screens/product_overview_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amar Shop',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => ProductOverviewScreen(),
        ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
      },
    );
  }
}
