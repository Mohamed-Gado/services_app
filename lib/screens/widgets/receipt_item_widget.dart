import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/invoice.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/screens/payment_screen.dart';
import 'package:service_app/screens/receipt_details_screen.dart';

class ReceiptItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final invoice = Provider.of<Invoice>(context);
    final isCustomer = Provider.of<Auth>(context).currentUser.isCustomer;
    String format(String time) {
      final minutes = double.parse(time).toInt();
      final seconds = double.parse(time).remainder(1) * 60;
      final duration = Duration(
        minutes: minutes,
        seconds: seconds.round(),
      );

      return duration.toString().split('.').first.padLeft(8, '0');
    }

    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Receipt Id ${invoice.invoiceId}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    '${invoice.currency}${invoice.totalAmount}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${DateFormat.yMEd().add_jms().format(DateTime.fromMillisecondsSinceEpoch(int.parse(invoice.createdAt) * 1000))}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    'Duration: ${format(invoice.workingMin)}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              Divider(color: Colors.black),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Services type: ',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        TextSpan(
                          text: '${invoice.categoryName}',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Theme.of(context).primaryColor),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      invoice.flag == '1' ? 'Paid' : 'Unpaid',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                      color: invoice.flag == '1' ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ],
              ),
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
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text(invoice.categoryName),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    ReceiptDetailsScreen.routeName,
                    arguments: invoice.id,
                  );
                },
                child: Text(
                  'View Invoice',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.grey, fontSize: 16),
                ),
              ),
              if (isCustomer && invoice.flag != '1')
                Divider(color: Colors.black),
              if (isCustomer && invoice.flag != '1')
                Center(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        PaymentScreen.routeName,
                        arguments: invoice.id,
                      );
                    },
                    child: Text(
                      'Pay now',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                          ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
