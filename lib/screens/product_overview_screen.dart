import 'package:amar_shop/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:amar_shop/providers/cart.dart';
import 'package:amar_shop/widgets/badge.dart';
import 'package:amar_shop/widgets/products_grid.dart';
import 'package:provider/provider.dart';
import 'package:amar_shop/screens/cart_screen.dart';
import 'package:amar_shop/providers/products.dart';

enum FilterValue {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Amar Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterValue selectedValue) {
              setState(() {
                if (selectedValue == FilterValue.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterValue.All,
              ),
              PopupMenuItem(
                child: Text('Show Favorites'),
                value: FilterValue.Favorites,
              )
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, pro, child) => Badge(
              child: child,
              value: pro.itemCount,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<Products>(context, listen: false).fetchAndSetProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error == null) {
              return ProductsGrid(_showOnlyFavorites);
            } else {
              return Center(
                child: Text('something went wrong'),
              );
            }
          }
        },
      ),
    );
  }
}
