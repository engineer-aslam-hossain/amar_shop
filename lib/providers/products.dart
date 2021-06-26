import 'dart:convert';
import 'package:amar_shop/models/http_exception.dart';

import 'product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  List<Product> _items = [];

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://amar-shop-efdfb-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);

      if (extractedData == null) {
        return;
      }
      final favUrl =
          'https://amar-shop-efdfb-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';

      final favoriteResponse = await http.get(Uri.parse(favUrl));
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          price: prodData['price'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
        _items = loadedProducts;
        notifyListeners();
      });
    } catch (err) {
      print(err);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://amar-shop-efdfb-default-rtdb.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }));

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateProduct(String id, Product newProdcut) async {
    final productIndx = _items.indexWhere((element) => element.id == id);

    if (productIndx >= 0) {
      final url =
          'https://amar-shop-efdfb-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProdcut.title,
            'price': newProdcut.price,
            'description': newProdcut.description,
            'imageUrl': newProdcut.imageUrl,
          }));
      _items[productIndx] = newProdcut;
      notifyListeners();
    } else {
      print('....');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://amar-shop-efdfb-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

    final existingProdIndex = _items.indexWhere((element) => element.id == id);
    var existingProd = _items[existingProdIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProdIndex, existingProd);
      notifyListeners();

      throw HttpException('Could not delete product');
    }
    existingProd = null;
  }
}
