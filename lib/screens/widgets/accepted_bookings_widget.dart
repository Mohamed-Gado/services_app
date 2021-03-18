import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/widgets/artist_booking_item_widget.dart';

class AcceptedBookingsWidget extends StatefulWidget {
  AcceptedBookingsWidget({Key key}) : super(key: key);

  @override
  _AcceptedBookingsWidgetState createState() => _AcceptedBookingsWidgetState();
}

class _AcceptedBookingsWidgetState extends State<AcceptedBookingsWidget> {
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<JobProvider>(context, listen: false)
          .getAllBookingsArtist('1')
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
    final bookings = Provider.of<JobProvider>(context).acceptedBookings;
    return isInit
        ? Center(
            child: CircularProgressIndicator(),
          )
        : bookings.length <= 0
            ? Center(
                child: Text('No Booking Found'),
              )
            : SingleChildScrollView(
                child: Column(
                  children: bookings
                      .map(
                        (booking) => ArtistBookingItemWidget(booking: booking),
                      )
                      .toList(),
                ),
              );
  }
}
