import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/booking.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/artist_bookings_screen.dart';

class ArtistBookingItemWidget extends StatelessWidget {
  final Booking booking;
  const ArtistBookingItemWidget({Key key, @required this.booking})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'New Request Found',
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontSize: 16,
                    ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 4.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      booking.userImage != null && booking.userImage != ''
                          ? NetworkImage(booking.userImage)
                          : AssetImage('assets/images/dummyuser_image.jpg'),
                ),
              ),
              Text(
                booking.userName,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.date_range,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      TextSpan(
                        text: ' ${booking.bookingDate} ${booking.bookingTime}',
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.location_on,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      TextSpan(text: ' ${booking.address}'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.description,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      TextSpan(text: ' ${booking.description}'),
                    ],
                  ),
                ),
              ),
              if (booking.flag == '0')
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showLoadingDialog(context);
                          Provider.of<JobProvider>(context, listen: false)
                              .bookingOperation('1', booking.id)
                              .then((value) {
                            Navigator.of(context).pushReplacementNamed(
                                ArtistBookingsScreen.routeName);
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.green,
                          ),
                          width: MediaQuery.of(context).size.width / 3,
                          height: 50,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.check,
                                    size: 26,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Accept',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showLoadingDialog(context);
                          Provider.of<JobProvider>(context, listen: false)
                              .declineOperation(booking.id)
                              .then((value) {
                            Navigator.of(context).pushReplacementNamed(
                                ArtistBookingsScreen.routeName);
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.red,
                          ),
                          width: MediaQuery.of(context).size.width / 3,
                          height: 50,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.close,
                                    size: 26,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Decline',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (booking.flag == '1')
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showLoadingDialog(context);
                          Provider.of<JobProvider>(context, listen: false)
                              .bookingOperation('2', booking.id)
                              .then((value) {
                            Navigator.of(context).pushReplacementNamed(
                                ArtistBookingsScreen.routeName);
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.green,
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.power_settings_new,
                                    size: 26,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: ' Start Job',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showLoadingDialog(context);
                          Provider.of<JobProvider>(context, listen: false)
                              .declineOperation(booking.id)
                              .then((value) {
                            Navigator.of(context).pushReplacementNamed(
                                ArtistBookingsScreen.routeName);
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 5,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.red,
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.close,
                                    size: 26,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (booking.flag == '4')
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Completed',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              if (booking.flag == '2')
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Rejected',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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

  showLoadingDialog(BuildContext ctx) {
    showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Row(
            children: [
              CircularProgressIndicator(),
              Container(
                margin: EdgeInsets.only(left: 7),
                child: Text("Please Wait..."),
              ),
            ],
          ),
        );
      },
    );
  }
}
