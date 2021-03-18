import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationItemWidget extends StatelessWidget {
  final String title;
  final String message;
  final DateTime date;
  const NotificationItemWidget({
    Key key,
    @required this.title,
    @required this.date,
    @required this.message,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 8.0,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        child: Container(
          child: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                ),
                Text(
                  DateFormat.yMEd().add_jms().format(date),
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontSize: 10,
                        color: Colors.grey[700],
                      ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                message,
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
