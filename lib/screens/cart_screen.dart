import 'package:amar_shop/providers/orders.dart';
import 'package:amar_shop/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amar_shop/providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total:",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, indx) => Cart_Item(
                id: cart.items.values.toList()[indx].id,
                productId: cart.items.keys.toList()[indx],
                title: cart.items.values.toList()[indx].title,
                price: cart.items.values.toList()[indx].price,
                quantity: cart.items.values.toList()[indx].quantity,
              ),
              itemCount: cart.items.length,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.cart.totalAmount <= 0
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
              setState(() {
                _isLoading = false;
              });
              widget.cart.clearCart();
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text('Order Now'.toUpperCase()),
    );
  }
}
