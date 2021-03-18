import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/widgets/artist_booking_item_widget.dart';

class RejectedBookingsWidget extends StatefulWidget {
  RejectedBookingsWidget({Key key}) : super(key: key);

  @override
  _RejectedBookingsWidgetState createState() => _RejectedBookingsWidgetState();
}

class _RejectedBookingsWidgetState extends State<RejectedBookingsWidget> {
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<JobProvider>(context, listen: false)
          .getAllBookingsArtist('2')
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
    final bookings = Provider.of<JobProvider>(context).rejectedBookings;
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
