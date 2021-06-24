import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:amar_shop/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});
}

class Orders with ChangeNotifier {
  final String authToken;
  List<OrderItem> _orders = [];

  Orders(this.authToken);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url =
        'https://amar-shop-efdfb-default-rtdb.firebaseio.com/orders.json?auth=$authToken';
    final res = await http.get(Uri.parse(url));
    final List<OrderItem> loadedData = [];

    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    print(res.body);
    if (extractedData == null) {
      return;
    }

    extractedData.forEach((itemId, itemData) {
      loadedData.add(
        OrderItem(
          id: itemId,
          amount: itemData['amount'],
          dateTime: DateTime.parse(itemData['dateTime']),
          products: (itemData['products'] as List<dynamic>)
              .map(
                (crtItem) => CartItem(
                  id: crtItem['id'],
                  title: crtItem['title'],
                  price: crtItem['price'],
                  quantity: crtItem['quantity'],
                ),
              )
              .toList(),
        ),
      );
    });

    _orders = loadedData.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://amar-shop-efdfb-default-rtdb.firebaseio.com/orders.json?auth=$authToken';
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((item) => {
                      'id': item.id,
                      'title': item.title,
                      'quantity': item.quantity,
                      'price': item.price,
                    })
                .toList(),
          }));

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (err) {}
  }
}
