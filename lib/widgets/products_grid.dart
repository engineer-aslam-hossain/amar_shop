import 'package:flutter/material.dart';
import 'package:amar_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorites;

  ProductsGrid(this.showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showOnlyFavorites ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (ctx, indx) => ChangeNotifierProvider.value(
        value: products[indx],
        child: ProductItem(),
      ),
      itemCount: products.length,
    );
  }
}
