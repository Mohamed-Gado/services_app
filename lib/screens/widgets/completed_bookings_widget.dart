import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/widgets/artist_booking_item_widget.dart';

class CompletedBookingsWidget extends StatefulWidget {
  CompletedBookingsWidget({Key key}) : super(key: key);

  @override
  _CompletedBookingsWidgetState createState() =>
      _CompletedBookingsWidgetState();
}

class _CompletedBookingsWidgetState extends State<CompletedBookingsWidget> {
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<JobProvider>(context, listen: false)
          .getAllBookingsArtist('4')
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
    final bookings = Provider.of<JobProvider>(context).completedBookings;
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
