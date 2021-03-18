import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/screens/artist_bookings_screen.dart';
import 'package:service_app/screens/chats_screen.dart';
import 'package:service_app/screens/my_booking_screen.dart';
import 'package:service_app/screens/notifications_screen.dart';

class BottomNavBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isCustomer = Provider.of<Auth>(context).currentUser.isCustomer;
    return Padding(
      padding: EdgeInsets.only(
        left: 4,
        right: 4,
      ),
      child: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.collections_bookmark),
                onPressed: () {
                  isCustomer
                      ? Navigator.of(context)
                          .pushReplacementNamed(MyBookingScreen.routeName)
                      : Navigator.of(context)
                          .pushReplacementNamed(ArtistBookingsScreen.routeName);
                },
              ),
              IconButton(
                color: Colors.white,
                icon: Icon(CupertinoIcons.chat_bubble_2_fill),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(ChatsScreen.routeName);
                },
              ),
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.notifications_active),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(NotificationsScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
