import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/widgets/booking_list_item_widget.dart';
import 'package:service_app/screens/widgets/bottom_ff_navbar_widget.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';

class MyBookingScreen extends StatefulWidget {
  static const routeName = '/my-booking-screen';

  @override
  _MyBookingScreenState createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  final _searchController = TextEditingController();
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Customer>(context, listen: false)
          .getMyCurrentBookingUser()
          .then((value) {
        setState(() {
          isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bookings = Provider.of<Customer>(context).searchBooking;
    final searchContainer = Container(
      padding: EdgeInsets.only(left: 8),
      margin: EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: TextField(
        cursorColor: Colors.grey,
        style: TextStyle(
          fontSize: 18.0,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
        onChanged: (text) {
          Provider.of<Customer>(context, listen: false).searchBookings(text);
        },
        maxLines: 1,
        autofocus: false,
        decoration: InputDecoration(
          icon: Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
          border: InputBorder.none,
          hintText: 'Search by Provider...',
          hintStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        controller: _searchController,
        onSubmitted: (_) {},
      ),
    );
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
        // drawer: AppDrawer(),
        bottomNavigationBar: BottomFFNavbarWidget(
          index: 1,
        ),
        appBar: AppBar(
          title: Text('My Bookings'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: searchContainer,
          ),
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => CustomDrawer.of(context).open(),
              );
            },
          ),
        ),
        body: isInit
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemBuilder: (ctx, i) {
                      return ChangeNotifierProvider.value(
                        value: bookings[i],
                        child: BookingListItemWidget(),
                      );
                    },
                    itemCount: bookings.length,
                  ),
                ),
              ),
      ),
    );
  }
}
