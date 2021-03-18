import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:service_app/screens/tickets_comments_screen.dart';

class TicketItemWidget extends StatelessWidget {
  final String id;
  final String title;
  final String status;
  final DateTime date;
  const TicketItemWidget({
    Key key,
    @required this.title,
    @required this.date,
    @required this.status,
    @required this.id,
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
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return TicketsCommentsScreen(id: id);
              }));
            },
            title: Text(
              title,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ),
            subtitle: Text(
              DateFormat.yMEd().add_jms().format(date),
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontSize: 10,
                    color: Colors.grey[700],
                  ),
            ),
            trailing: Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: status == '1'
                      ? Theme.of(context).accentColor
                      : status == '0'
                          ? Colors.red
                          : Colors.green,
                ),
                padding: EdgeInsets.all(4.0),
                child: Text(
                  status == '1'
                      ? 'Solve'
                      : status == '0'
                          ? 'Pending'
                          : 'Close',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
