import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/widgets/add_ticket_widget.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';
import 'package:service_app/screens/widgets/ticket_item_widget.dart';

class TicketsScreen extends StatelessWidget {
  static const routeName = '/tickets-screen';

  Future<void> _getTickets(BuildContext ctx) async {
    await Provider.of<JobProvider>(ctx, listen: false).getTickets();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Uclab Service App?'),
              content: new Text('Do you want to close Service App?'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            showModalBottomSheet(
              isDismissible: true,
              isScrollControlled: true,
              context: context,
              builder: (_) {
                return AddTicketWidget();
              },
            );
          },
        ),
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => CustomDrawer.of(context).open(),
              );
            },
          ),
          centerTitle: true,
          title: Text('Support'),
        ),
        body: FutureBuilder(
          future: _getTickets(context),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<JobProvider>(
                  builder: (ctx, jobProvider, _) => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: jobProvider.tickets.length,
                      itemBuilder: (_, i) => TicketItemWidget(
                        id: jobProvider.tickets[i].id,
                        title: jobProvider.tickets[i].reason,
                        status: jobProvider.tickets[i].status,
                        date: DateTime.fromMillisecondsSinceEpoch(
                            int.parse(jobProvider.tickets[i].createdAt) * 1000),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
