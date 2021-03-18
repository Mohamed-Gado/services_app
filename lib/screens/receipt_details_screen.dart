import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/payment_screen.dart';

class ReceiptDetailsScreen extends StatelessWidget {
  static const routeName = '/receipt-Details-screen';
  @override
  Widget build(BuildContext context) {
    final isCustomer = Provider.of<Auth>(context).currentUser.isCustomer;
    final invoiceId = ModalRoute.of(context).settings.arguments as String;
    final invoice = Provider.of<Customer>(context)
        .invoices
        .firstWhere((element) => element.id == invoiceId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Receipt Id ${invoice.invoiceId}',
          style: Theme.of(context)
              .appBarTheme
              .textTheme
              .headline6
              .copyWith(color: Colors.black),
        ),
        leading: IconButton(
          color: Colors.grey,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage:
                  invoice.artistImage != null && invoice.artistImage != ''
                      ? NetworkImage(invoice.artistImage)
                      : AssetImage('assets/images/dummyuser_image.jpg'),
            ),
            title: Text(
              invoice.artistName,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Text(invoice.categoryName),
          ),
          Divider(
            height: 0,
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 2) - 32,
                    child: Text(
                      'Invoice Date\n${DateFormat.yMEd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(invoice.createdAt) * 1000))}\n${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(invoice.createdAt) * 1000))}',
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                VerticalDivider(),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 2) - 32,
                    child: Text(
                      'Due Date\n${DateFormat.yMEd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(invoice.createdAt) * 1000))}\n${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(invoice.createdAt) * 1000))}',
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              invoice.categoryName,
              style: Theme.of(context).textTheme.headline6,
            ),
            trailing: Text(
              '${invoice.currency}${invoice.finalAmount}',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Subtotal',
              style: Theme.of(context).textTheme.headline6,
            ),
            trailing: Text(
              '${invoice.currency}${invoice.totalAmount}',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Discount',
              style: Theme.of(context).textTheme.headline6,
            ),
            trailing: Text(
              '${invoice.currency}${invoice.discountAmount.isEmpty ? 0.0 : invoice.discountAmount}',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Total',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              '${invoice.currency}${invoice.finalAmount.isEmpty ? 0.0 : invoice.finalAmount}',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          if (isCustomer && invoice.flag == '0')
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  PaymentScreen.routeName,
                  arguments: invoice.id,
                );
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                width: 250,
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'PAY NOW',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
