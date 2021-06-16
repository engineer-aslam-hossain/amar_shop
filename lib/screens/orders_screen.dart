import 'package:amar_shop/widgets/app_drawer.dart';
import 'package:amar_shop/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:amar_shop/providers/orders.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = 'orders_screen';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, indx) => OrderdItem(ordersData.orders[indx]),
        itemCount: ordersData.orders.length,
      ),
    );
  }
}
