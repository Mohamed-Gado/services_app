import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/widgets/bottom_ff_navbar_widget.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';
import 'package:service_app/screens/widgets/notification_item_widget.dart';

class NotificationsScreen extends StatelessWidget {
  static const routeName = '/notifications-screen';

  Future<void> _getNotifications(BuildContext ctx) async {
    await Provider.of<JobProvider>(ctx, listen: false).getNotifications();
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
        bottomNavigationBar: BottomFFNavbarWidget(
          index: 3,
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
          title: Text('Notifications'),
        ),
        body: FutureBuilder(
          future: _getNotifications(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<JobProvider>(
                      builder: (ctx, jobProvider, _) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: jobProvider.notifications.length,
                          itemBuilder: (_, i) => NotificationItemWidget(
                            title: jobProvider.notifications[i].title,
                            message: jobProvider.notifications[i].message,
                            date: DateTime.fromMillisecondsSinceEpoch(
                                int.parse(jobProvider.notifications[i].date) *
                                    1000),
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
