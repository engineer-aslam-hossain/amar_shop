import 'dart:math';
import 'package:flutter/material.dart';
import 'package:amar_shop/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderdItem extends StatefulWidget {
  final OrderItem orderItem;

  OrderdItem(this.orderItem);

  @override
  _OrderdItemState createState() => _OrderdItemState();
}

class _OrderdItemState extends State<OrderdItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderItem.amount.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('dd-MMM-yyyy, hh:mm')
                  .format(widget.orderItem.dateTime),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          // Divider(),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.orderItem.products.length * 20.0 + 20, 180),
              child: ListView(
                children: widget.orderItem.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prod.title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${prod.quantity}x  \$${prod.price}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            )
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
