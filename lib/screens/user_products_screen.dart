import 'package:flutter/material.dart';
import 'package:amar_shop/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:amar_shop/screens/edit_product_screen.dart';
import 'package:amar_shop/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user_product_screen';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemBuilder: (ctx, indx) => UserProductItem(
            productsData.items[indx].title,
            productsData.items[indx].imageUrl,
          ),
          itemCount: productsData.items.length,
        ),
      ),
    );
  }
}