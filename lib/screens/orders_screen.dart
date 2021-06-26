import 'package:amar_shop/widgets/app_drawer.dart';
import 'package:amar_shop/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:amar_shop/providers/orders.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error == null) {
              return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                        itemBuilder: (ctx, indx) =>
                            OrderdItem(orderData.orders[indx]),
                        itemCount: orderData.orders.length,
                      ));
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
