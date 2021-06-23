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

var _isInit = true;
var _isLoading = false;

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/product_preview_screen';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavorites = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<Products>(context).fetchAndSetProducts();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
